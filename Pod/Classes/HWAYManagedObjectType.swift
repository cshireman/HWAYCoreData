//
//  HWAYManagedObjectType.swift
//  threadedcd
//
//  Created by Chris Shireman on 10/8/15.
//  Copyright © 2015 Hathway. All rights reserved.
//

import Foundation
import SwiftyJSON

public protocol HWAYManagedObjectType: class {
    static var entityName: String { get }
    static var externalIdField: String { get }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }

    func loadFromJSON(data:JSON)
}
