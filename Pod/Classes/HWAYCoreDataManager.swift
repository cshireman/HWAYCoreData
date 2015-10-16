//
//  HWAYCoreDataManager.swift
//  threadedcd
//
//  Created by Chris Shireman on 10/8/15.
//  Copyright © 2015 Hathway. All rights reserved.
//

import Foundation
import CoreData

public class HWAYCoreDataManager: NSObject {

    public static var sharedInstance = HWAYCoreDataManager()

    private var stacks: [String:HWAYCoreDataStack] = [:]

    /**
    Setup the core data stack for the given name.  The name of the stack must match
    the name of the data model.  If a stack already exists for the requested name, the 
    existing stack is returned.  Main queue concurrency is used

    - parameter stackName: The name of the stack to setup
    - returns: The core data stack for the requested stack name
    */
    public func coreDataStack(withStackName stackName:String) -> HWAYCoreDataStack
    {
        guard let stack: HWAYCoreDataStack = stacks[stackName] else {
            let newStack = HWAYCoreDataStack(withStackName: stackName)

            stacks[stackName] = newStack
            return newStack
        }

        return stack
    }

    /**
    Get the default stack for this app.  The name of the stack is assumed to be the same as the bundle name

    - returns: The default core data stack
    */
    public static func defaultCoreDataStack() -> HWAYCoreDataStack {
        let info = NSBundle.mainBundle().infoDictionary

        guard info != nil else {
            return HWAYCoreDataManager.sharedInstance.coreDataStack(withStackName: "Main")
        }

        let defaultStackName: String? = info!["CFBundleName"] as? String
        return HWAYCoreDataManager.sharedInstance.coreDataStack(withStackName: defaultStackName ?? "Main")
    }

    /**
    Get the default managed object context

    - returns: The default context for the default stack
    */
    public static func defaultManagedObjectContext() -> NSManagedObjectContext {
        let stack = HWAYCoreDataManager.defaultCoreDataStack()
        return stack.context
    }
}
