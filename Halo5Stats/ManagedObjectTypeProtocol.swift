//
//  ManagedObjectTypeProtocol.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation
import CoreData

public protocol ManagedObjectTypeProtocol: class {
    static var entityName: String { get }

    static func parse(data: [String : AnyObject], context: NSManagedObjectContext)
    func update(withData data: AnyObject, context: NSManagedObjectContext)
}

extension ManagedObjectTypeProtocol {
    static func parse(data: [String : AnyObject], context: NSManagedObjectContext) {
        // Make this function optional
    }

    func update(withData data: AnyObject, context: NSManagedObjectContext) {
        // Make this function optional
    }
}
