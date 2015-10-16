//
//  HWAYCoreDataStack.swift
//  threadedcd
//
//  Created by Chris Shireman on 10/8/15.
//  Copyright © 2015 Hathway. All rights reserved.
//

import UIKit
import CoreData

public class HWAYCoreDataStack: NSObject {
    public private(set) var context: NSManagedObjectContext
    public private(set) var storeCoordinator: NSPersistentStoreCoordinator

    /**
    Create a new core data stack using the given name

    - parameter stackName: The name of the stack

    - returns: The newly created stack
    */
    init(withStackName stackName:String){
            let fileManager = NSFileManager.defaultManager()
            let bundle = NSBundle.mainBundle()
            let documentDirectoryURL = try! fileManager.URLForDirectory(.DocumentDirectory,
                inDomain: .UserDomainMask, appropriateForURL: nil, create: true)

            let storeURL = documentDirectoryURL
                .URLByAppendingPathComponent(stackName)
                .URLByAppendingPathExtension(".sqlite")

            if !NSFileManager.defaultManager().fileExistsAtPath(storeURL.path!) {
                let preloadedURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(stackName, ofType: "storedata")!)
                if NSFileManager.defaultManager().fileExistsAtPath(preloadedURL.path!) {
                    try! NSFileManager.defaultManager().copyItemAtURL(preloadedURL, toURL: storeURL)
                }
            }

            var modelURL = bundle.URLForResource(stackName, withExtension: "momd")
            if modelURL == nil {
                modelURL = bundle.URLForResource(stackName, withExtension: "mom")

                guard modelURL != nil else {
                    fatalError("Could not find model")
                }
            }

            guard let model = NSManagedObjectModel(contentsOfURL: modelURL!) else {
                fatalError("Could not load model")
            }

            storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
            try! storeCoordinator.addPersistentStoreWithType(NSSQLiteStoreType,
                configuration: nil,
                URL: storeURL,
                options: nil)

            context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
            context.persistentStoreCoordinator = storeCoordinator
    }

    /**
    Create a child context to the main context of this stack

    - returns: The child context of the stacks main context.  This context is created with a 
    private queue concurrency type
    */
    public func createChildContext() -> NSManagedObjectContext {
        let childContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        childContext.parentContext = context

        return childContext
    }
}
