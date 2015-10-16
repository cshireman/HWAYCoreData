//
//  HWAYManagedObjectType+Find.swift
//  threadedcd
//
//  Created by Chris Shireman on 10/9/15.
//  Copyright © 2015 Hathway. All rights reserved.
//

import Foundation
import CoreData

extension HWAYManagedObjectType where Self: HWAYManagedObject {
    /**
    Find or create a managed object in the given context with the given external id.

    - parameter context:    The context to use for the managed object
    - parameter externalId: The external id of the object.

    - returns: The existing or new managed object in the given context.
    */
    public static func findOrCreate(inContext context:NSManagedObjectContext, withExternalId externalId: NSNumber) -> Self {
        let predicate = NSPredicate(format: "%@ == %@", Self.externalIdField, externalId)
        let result: Self = findOrCreate(inContext: context, matchingPredicate:predicate)
        return result
    }

    /**
    Find or create a managed object in the given context with the given predicate.

    - parameter context:    The context to use for the managed object
    - parameter predicate:  The predicate to use when searching for an existing object.

    - returns: The existing or new managed object in the given context.
    */
    public static func findOrCreate(inContext context: NSManagedObjectContext, matchingPredicate predicate:NSPredicate) -> Self {
        guard let obj: Self = findOrFetch(inContext: context, matchingPredicate: predicate) else {
            let newObject: Self = context.insertObject()
            return newObject
        }

        return obj
    }

    /**
    Find or fetch the managed object described by the given predicate in the given context.
    The context is first checked for objects in memory before making a fetch request.

    - parameter context:   The context to search or fetch from
    - parameter predicate: The predicate to use for searching and potentially the fetch request

    - returns: If the object is found, it is returned.  Otherwise nil.
    */
    public static func findOrFetch(inContext context:NSManagedObjectContext, matchingPredicate predicate: NSPredicate) -> Self? {
        guard let obj: Self = materializedObject(inContext: context, matchingPredicate: predicate) else {
            return fetchInContext(context) { request in
                request.predicate = predicate
                request.returnsObjectsAsFaults = false
                request.fetchLimit = 1
                }.first
        }

        return obj
    }

    /**
    Search the registered objects in the given context for one that matches given predicate.

    - parameter context:   The context to search in
    - parameter predicate: The predicate to use for object evaluation

    - returns: If found, the first object satisfying the predicate.
    */
    public static func materializedObject(inContext context: NSManagedObjectContext, matchingPredicate predicate: NSPredicate) -> Self? {
        for obj in context.registeredObjects where !obj.fault {
            guard let result = obj as? Self where predicate.evaluateWithObject(result) else {
                continue
            }

            return result
        }

        return nil
    }

    /**
    Perform a fetch request in the given context.

    - parameter context:            The context to fetch from
    - parameter configurationBlock: The configuration block.  Configure your fetch request here.

    - returns: An array of mananged objects, which could be empty.
    */
    public static func fetchInContext(context: NSManagedObjectContext, @noescape configurationBlock: NSFetchRequest -> ()) -> [Self]{
        let request = NSFetchRequest(entityName: Self.entityName)
        configurationBlock(request)
        guard let result = try! context.executeFetchRequest(request) as? [Self] else {
            fatalError("Fetched objects have wrong type")
        }
        
        return result
    }


}
