//
//  NSManagedObjectTypeProtocol+Extensions.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import CoreData

extension ManagedObjectTypeProtocol where Self: NSManagedObject {

    public static func fetch(inContext context: NSManagedObjectContext, @noescape configurationBlock: NSFetchRequest -> () = { _ in }) -> [Self] {
        let request = NSFetchRequest(entityName: Self.entityName)
        configurationBlock(request)
        guard let result = try! context.executeFetchRequest(request) as? [Self] else { fatalError("Fetched objects have wrong type.") }
        return result
    }

    public static func materializeObject(inContext context: NSManagedObjectContext, matchingPredicate predicate: NSPredicate) -> Self? {
        for object in context.registeredObjects where !object.fault {
            guard let result = object as? Self where predicate.evaluateWithObject(result) else { continue }
            return result
        }

        return nil
    }

    public static func findOrFetch(inContext context: NSManagedObjectContext, matchingPredicate predicate: NSPredicate) -> Self? {
        guard let object = materializeObject(inContext: context, matchingPredicate: predicate) else {
            return fetch(inContext: context) { request in
                request.predicate = predicate
                request.returnsObjectsAsFaults = false
                request.fetchLimit = 1
            }.first
        }

        return object
    }

    public static func findOrCreate(inContext context: NSManagedObjectContext, matchingPredicate predicate: NSPredicate, shouldUpdate: Bool = true, configure: Self -> ()) -> Self {
        guard let object = findOrFetch(inContext: context, matchingPredicate: predicate) else {
            let newObject: Self = context.insertObject()
            configure(newObject)
            return newObject
        }

        if shouldUpdate {
            configure(object)
        }

        return object
    }

    public static func objects(forData data: [AnyObject], context: NSManagedObjectContext) -> [Self] {
        var newObjects: [Self] = []
        for obj in data {
            let newObj: Self = context.insertObject()
            newObj.update(withData: obj, context: context)
            newObjects.append(newObj)
        }
        return newObjects
    }
}
