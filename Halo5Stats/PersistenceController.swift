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
    
    // MARK: Properties
    
    fileprivate static let storePath = "Halo5Stats.sqlite"
    let managedObjectContext: NSManagedObjectContext!
    let privateManagedObjectContext: NSManagedObjectContext
    
    // MARK: Initialization
    
    init(coordinator: NSPersistentStoreCoordinator) {
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        privateManagedObjectContext.persistentStoreCoordinator = coordinator
        managedObjectContext.parent = privateManagedObjectContext
        
        addChildSaveNotification()
    }
    
    // MARK: Static Methods
    
    static func persistenceStoreURL() -> URL {
        guard var url = Foundation.FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            fatalError("The persistence store URL doesn't exist")
        }
        
        url = url.appendingPathComponent(storePath)

        return url
    }
    
    // MARK: Internal
    
    func persistenceStoreExists() -> Bool {
        return managedObjectContext != nil
    }
    
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
    
    // MARK: - Child Context
    
    // MARK: Internal
    
    func createChildContext() -> NSManagedObjectContext {
        let childContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        childContext.parent = managedObjectContext
        
        return childContext
    }
    
    func saveChildContext(_ context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                print("Error saving child context: \(error)")
            }
        }
    }
    
    // MARK: Private
    
    fileprivate func addChildSaveNotification() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSManagedObjectContextDidSave, object: nil, queue: nil) { [weak self] (notification) -> Void in
            guard let strongSelf = self else { return }
            guard let mainContext = strongSelf.managedObjectContext else { return }
            guard let childContext = notification.object as? NSManagedObjectContext else { return }
            
            if childContext.persistentStoreCoordinator == mainContext.persistentStoreCoordinator {
                if childContext != mainContext {
                    mainContext.perform({ [weak strongSelf] () -> Void in
                        guard let strongSelf = strongSelf else { return }
                        mainContext.mergeChanges(fromContextDidSave: notification)
                        strongSelf.save()
                    })
                }
            }
        }
    }
}
