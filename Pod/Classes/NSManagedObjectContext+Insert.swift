//
//  NSManagedObjectContext+Insert.swift
//  threadedcd
//
//  Created by Chris Shireman on 10/8/15.
//  Copyright © 2015 Hathway. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    /**
    Wrapper around managed object insertion

    - returns: A new managed object
    */
    public func insertObject<A: HWAYManagedObject where A: HWAYManagedObjectType>() -> A {
        guard let obj = NSEntityDescription.insertNewObjectForEntityForName(A.entityName,
            inManagedObjectContext: self) as? A else {
                fatalError("Wrong object type")
        }

        return obj
    }

}
