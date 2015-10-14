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

    private var stacks: [String:HWAYCoreDataStack] = [:]

    /**
    Setup the core data stack for the given name.  The name of the stack must match
    the name of the data model.  If a stack already exists for the requested name, the 
    existing stack is returned.  Main queue concurrency is used

    - parameter stackName: The name of the stack to setup
    - returns: The managed object context for the requested stack
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
}
