//
//  PersistenceController.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation
import CoreData

class PersistenceController {
    
    // MARK: - Persistence Controller

    struct K {
        static let storePath = "Halo5Stats.sqlite"
    }
    
    // MARK: Properties

    let managedObjectContext: NSManagedObjectContext
    let privateManagedObjectContext: NSManagedObjectContext

    private let coordinator: NSPersistentStoreCoordinator

    var persistentStoreExists: Bool {
        return coordinator.persistentStores.isEmpty == false
    }
    
    // MARK: Initialization

    init?() {
        guard let model = NSManagedObjectModel.mergedModel(from: nil) else { return nil }

        coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)

        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)

        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator

        let storeUrl = type(of: self).persistenceStoreURL()
        var error = buildStore(with: coordinator, at: storeUrl)

        if coordinator.persistentStores.isEmpty {
            destroyStore(with: coordinator, at: storeUrl)
            error = buildStore(with: coordinator, at: storeUrl)
        }

        if coordinator.persistentStores.isEmpty {
            if let error = error {
                print("Error creating SQLite store: \(error)")
            }
            print("Falling back to InMemoryStore type.")

            error = buildStore(with: coordinator, at: storeUrl, type: NSInMemoryStoreType)
        }

        guard error == nil else { return nil }

        privateManagedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        privateManagedObjectContext.persistentStoreCoordinator = coordinator

        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        managedObjectContext.parent = privateManagedObjectContext

        addChildSaveNotification()
    }

    // MARK: Static Methods
    
    static func persistenceStoreURL() -> URL {
        guard var url = Foundation.FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            fatalError("The persistence store URL doesn't exist")
        }
        
        url = url.appendingPathComponent(K.storePath)

        return url
    }
    
    // MARK: Internal
    
    func save() {
        if !privateManagedObjectContext.hasChanges && !managedObjectContext.hasChanges {
            return
        }
        
        managedObjectContext.performAndWait { () -> Void in            
            do {
                try self.managedObjectContext.save()
            } catch {
                let error = error as NSError
                NSLog("Unresolved error \(error), \(error.userInfo)")
            }
            
            self.privateManagedObjectContext.perform { () -> Void in
                do {
                    try self.privateManagedObjectContext.save()
                } catch {
                    let privateError = error as NSError
                    NSLog("Unresolved error \(privateError), \(privateError.userInfo)")
                }
            }
        }
    }
    
    func createChildContext() -> NSManagedObjectContext {
        let childContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        childContext.parent = managedObjectContext
        
        return childContext
    }
    
    func save(context: NSManagedObjectContext) {
        guard persistentStoreExists, context.hasChanges else { return }

        do {
            try context.save()
        } catch let error {
            assertionFailure("Error saving context \(context): \(error)")
        }
    }

    // MARK: Private

    private func buildStore(with coordinator: NSPersistentStoreCoordinator, at url: URL, type: String = NSSQLiteStoreType) -> NSError? {
        var error: NSError?

        do {
            let options = [NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true]
            try coordinator.addPersistentStore(ofType: type, configurationName: nil, at: url, options: options)
        } catch let storeError as NSError {
            error = storeError
        }

        return error
    }

    private func destroyStore(with coordinator: NSPersistentStoreCoordinator, at url: URL, type: String = NSSQLiteStoreType) {
        do {
            try coordinator.destroyPersistentStore(at: url, ofType: type, options: nil)
        } catch {}
    }
    
    private func addChildSaveNotification() {
        let completion: (Notification) -> Void = { [weak self] notification in
            guard let strongSelf = self else { return }
            guard let childContext = notification.object as? NSManagedObjectContext else { return }

            let mainContext = strongSelf.managedObjectContext

            guard childContext.persistentStoreCoordinator == mainContext.persistentStoreCoordinator && childContext != mainContext else { return }

            mainContext.perform({ [weak strongSelf] () -> Void in
                guard let strongSelf = strongSelf else { return }
                mainContext.mergeChanges(fromContextDidSave: notification)
                strongSelf.save()
            })
        }

        NotificationCenter.default.addObserver(forName: Notification.Name.NSManagedObjectContextDidSave, object: nil, queue: nil, using: completion)
    }
}
