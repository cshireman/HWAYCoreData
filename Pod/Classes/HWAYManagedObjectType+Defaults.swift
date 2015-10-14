//
//  HWAYManagedObjectType+Defaults.swift
//  threadedcd
//
//  Created by Chris Shireman on 10/8/15.
//  Copyright © 2015 Hathway. All rights reserved.
//

import Foundation
import CoreData

extension HWAYManagedObjectType {
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return []
    }

    public static var sortedFetchRequest: NSFetchRequest {
        let request = NSFetchRequest(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors

        return request
    }

    public var externalId: NSNumber {
        return NSNumber(int: 0)
    }

    /**
    Create a sorted fetch request for this managed object using the given predicate

    - parameter predicate: The predicate to combine with the default sort fetch request

    - returns: A sorted fetch request for this managed object with the given predicate
    */
    public static func sortedFetchRequestWithPredicate(predicate: NSPredicate) -> NSFetchRequest {
        let fetchRequest = sortedFetchRequest
        guard let existingPredicate = fetchRequest.predicate else {
            fetchRequest.predicate = predicate
            return fetchRequest
        }

        fetchRequest.predicate = NSCompoundPredicate(
            andPredicateWithSubpredicates: [existingPredicate, predicate]
        )

        return fetchRequest
    }
}
