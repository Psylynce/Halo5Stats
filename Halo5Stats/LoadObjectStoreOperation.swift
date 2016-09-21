//
//  LoadObjectStoreOperation.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class LoadObjectStoreOperation: Operation {
    
    // MARK: Initialization
    
    override init() {
        super.init()
        
        addCondition(MutuallyExclusive<LoadObjectStoreOperation>())
        
        name = "Load Object Store"
    }
    
    override func execute() {
        let appController = UIApplication.appController()

        let persistenceController = appController.persistenceController

        if let persistenceController = persistenceController {
            if persistenceController.persistenceStoreExists() {
                finish()

                return
            }
        }

        var error: NSError? = nil

        guard let modelURL = NSBundle.mainBundle().URLForResource("Halo5Stats", withExtension: "momd") else {
            fatalError("Error loading model from bundle")
        }
        guard let model = NSManagedObjectModel(contentsOfURL: modelURL) else {
            fatalError("Error initializing mom from \(modelURL)")
        }

        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)

        let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator

        let storeURL = PersistenceController.persistenceStoreURL()
        error = createStore(coordinator, url: storeURL)

        if coordinator.persistentStores.isEmpty {
            destroyStore(coordinator, atURL: storeURL)
            error = createStore(coordinator, url: storeURL)
        }

        if coordinator.persistentStores.isEmpty {
            print("Error creating SQLite store. \(error)")
            error = createStore(coordinator, url: storeURL, type: NSInMemoryStoreType)
        }

        if !coordinator.persistentStores.isEmpty {
            let controller = PersistenceController(coordinator: coordinator)
            appController.persistenceController = controller
            print("Store Created!")

            error = nil
        }

        finishWithError(error)
    }

    override func finished(errors: [NSError]) {
        guard let firstError = errors.first where userInitiated else { return }

        let alert = AlertOperation()

        alert.title = "Unable to load database"
        
        alert.message = "An error occurred while loading the database. \(firstError.localizedDescription) Please try again later."
        
        alert.addAction("Retry Later", style: .Cancel)
        
        alert.addAction("Retry Now") { alertOperation in
            let retryOperation = InitializeObjectStoreOperation()
            
            retryOperation.userInitiated = true
            
            alertOperation.produceOperation(retryOperation)
        }
        
        produceOperation(alert)
    }
    
    // MARK: Private
    
    private func createStore(persistenceStoreCoordinator: NSPersistentStoreCoordinator, url: NSURL?, type: String = NSSQLiteStoreType) -> NSError? {
        var error: NSError?
        
        do {
            let options = [NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true]
            let _ = try persistenceStoreCoordinator.addPersistentStoreWithType(type, configuration: nil, URL: url, options: options)
        } catch let storeError as NSError {
            error = storeError
        }
        
        return error
    }
    
    private func destroyStore(persistentStoreCoordinator: NSPersistentStoreCoordinator, atURL URL: NSURL, type: String = NSSQLiteStoreType) {
        do {
            let _ = try persistentStoreCoordinator.destroyPersistentStoreAtURL(URL, withType: type, options: nil)
        } catch { }
    }
}
