//
//  ImportOperation.swift
//  threadedcd
//
//  Created by Chris Shireman on 9/4/15.
//  Copyright © 2015 Hathway. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftyJSON

protocol HWAYImportOperationDelegate {
    func importUpdatedWithPercentage(percent: Float)
    func importCompleted()
}

typealias HWAYImportProgressUpdateBlock = (Float)->Void
typealias HWAYImportProcessingCallback = (JSON,HWAYImportProgressUpdateBlock) -> Void

class HWAYImportOperation: NSOperation {
    var stack: HWAYCoreDataStack?
    var context: NSManagedObjectContext?
    var delegate: ImportOperationDelegate?
    var url: String?

    var processingCallback: HWAYImportProcessingCallback?

    override func main() {
        if context == nil {
            context = stack?.createChildContext()
        }

        Alamofire.request(.GET, self.url)
            .responseJSON { (request, response, json) -> Void in
                //Dispatch in background thread to prevent response handling on the main thread
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                    let jsonData: JSON = JSON(json.value!)

                    self.processingCallback?(jsonData) { percent -> Void in
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.delegate?.importUpdatedWithPercentage(percent)
                        })
                    }

                    if self.context?.hasChanges {
                        do {
                            try self.context?.save()
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.delegate?.importCompleted()
                            })
                        } catch {
                            NSLog("Error: \(error)")
                        }
                    } else {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.delegate?.importCompleted()
                        })
                    }
                })
        }
    }
}
