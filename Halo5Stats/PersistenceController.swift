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
    
    private static let storePath = "Halo5Stats.sqlite"
    let managedObjectContext: NSManagedObjectContext!
    let privateManagedObjectContext: NSManagedObjectContext
    
    // MARK: Initialization
    
    init(coordinator: NSPersistentStoreCoordinator) {
        managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        
        privateManagedObjectContext.persistentStoreCoordinator = coordinator
        managedObjectContext.parentContext = privateManagedObjectContext
        
        addChildSaveNotification()
    }
    
    // MARK: Static Methods
    
    static func persistenceStoreURL() -> NSURL {
        guard var url = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last else {
            fatalError("The persistence store URL doesn't exist")
        }
        
        url = url.URLByAppendingPathComponent(storePath)

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
        
        managedObjectContext.performBlockAndWait { () -> Void in            
            do {
                try self.managedObjectContext.save()
            } catch {
                let error = error as NSError
                NSLog("Unresolved error \(error), \(error.userInfo)")
            }
            
            self.privateManagedObjectContext.performBlock { () -> Void in
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
        let childContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        childContext.parentContext = managedObjectContext
        
        return childContext
    }
    
    func saveChildContext(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                print("Error saving child context: \(error)")
            }
        }
    }
    
    // MARK: Private
    
    private func addChildSaveNotification() {
        NSNotificationCenter.defaultCenter().addObserverForName(NSManagedObjectContextDidSaveNotification, object: nil, queue: nil) { [weak self] (notification) -> Void in
            guard let strongSelf = self else { return }
            guard let mainContext = strongSelf.managedObjectContext else { return }
            guard let childContext = notification.object as? NSManagedObjectContext else { return }
            
            if childContext.persistentStoreCoordinator == mainContext.persistentStoreCoordinator {
                if childContext != mainContext {
                    mainContext.performBlock({ [weak strongSelf] () -> Void in
                        guard let strongSelf = strongSelf else { return }
                        mainContext.mergeChangesFromContextDidSaveNotification(notification)
                        strongSelf.save()
                    })
                }
            }
        }
    }
}
