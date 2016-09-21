//
//  NSManagedObjectContext+Extensions.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import CoreData

extension NSManagedObjectContext {

    public func insertObject<A: NSManagedObject where A: ManagedObjectTypeProtocol>() -> A {
        guard let obj = NSEntityDescription.insertNewObjectForEntityForName(A.entityName, inManagedObjectContext: self) as? A else { fatalError("Wrong object type") }
        return obj
    }
}
