//
//  NSManagedObjectContext+Insert.swift
//  threadedcd
//
//  Created by Chris Shireman on 10/8/15.
//  Copyright © 2015 Hathway. All rights reserved.
//

import Foundation
import CoreData

public typealias HWAYContextNotificationBlock = (NSNotification) -> Void

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

    public func addContextDidSaveNotificationObserver(block: (NSNotification)-> Void) {
        NSNotificationCenter.defaultCenter().addObserverForName(
            NSManagedObjectContextDidSaveNotification,
            object: self,
            queue: nil,
            usingBlock: block)
    }

    public func performMergeChangesFromContextDidSaveNotification(
        notification: NSNotification) {
        performBlock {
            self.mergeChangesFromContextDidSaveNotification(notification)
        }
    }

    public func saveOrRollback() -> Bool{
        do {
            try save()
            return true
        } catch {
            rollback()
            return false
        }
    }

    public func performChanges(block: ()->()) {
        performBlock({
            block()
            self.saveOrRollback()
        })
    }
}
