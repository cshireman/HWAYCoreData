//
//  HWAYManagedObjectType+Load.swift
//  threadedcd
//
//  Created by Chris Shireman on 10/12/15.
//  Copyright © 2015 Hathway. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

extension HWAYManagedObjectType where Self: HWAYManagedObject {
    public static func loadFromJSONArray(data:JSON, inContext context:NSManagedObjectContext, postProcess:((Self,JSON)->Void)?) -> [Self] {
        var results: [Self] = []
        if let objects: Array<JSON>? = data.array {
            for jsonObject: JSON in objects! {
                let object: Self = Self.findOrCreate(
                    inContext: context,
                    withExternalId: jsonObject["id"].numberValue
                )

                object.loadFromJSON(jsonObject)
                postProcess?(object,jsonObject)
                results.append(object)
            }
        }

        return results
    }
}