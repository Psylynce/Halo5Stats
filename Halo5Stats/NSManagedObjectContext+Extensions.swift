//
//  NSManagedObjectContext+Extensions.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import CoreData

extension NSManagedObjectContext {

    public func insertObject<A: NSManagedObject>() -> A where A: ManagedObjectTypeProtocol {
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: A.entityName, into: self) as? A else { fatalError("Wrong object type") }
        return obj
    }
}
