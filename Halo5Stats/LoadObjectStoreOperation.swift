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

        var error: Error? = nil

        guard let modelURL = Bundle.main.url(forResource: "Halo5Stats", withExtension: "momd") else {
            fatalError("Error loading model from bundle")
        }
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from \(modelURL)")
        }

        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)

        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator

        let storeURL = PersistenceController.persistenceStoreURL()
        error = createStore(coordinator, url: storeURL as URL)

        if coordinator.persistentStores.isEmpty {
            destroyStore(coordinator, atURL: storeURL as URL)
            error = createStore(coordinator, url: storeURL as URL)
        }

        if coordinator.persistentStores.isEmpty {
            print("Error creating SQLite store.")
            error = createStore(coordinator, url: storeURL as URL, type: NSInMemoryStoreType)
        }

        if !coordinator.persistentStores.isEmpty {
            let controller = PersistenceController(coordinator: coordinator)
            appController.persistenceController = controller
            print("Store Created!")

            error = nil
        }

        finishWithError(error)
    }

    override func finished(_ errors: [Error]) {
        guard let firstError = errors.first, userInitiated else { return }

        let alert = AlertOperation()

        alert.title = "Unable to load database"
        
        alert.message = "An error occurred while loading the database. \(firstError.localizedDescription) Please try again later."
        
        alert.addAction("Retry Later", style: .cancel)
        
        alert.addAction("Retry Now") { alertOperation in
            let retryOperation = InitializeObjectStoreOperation()
            
            retryOperation.userInitiated = true
            
            alertOperation.produceOperation(retryOperation)
        }
        
        produceOperation(alert)
    }
    
    // MARK: Private
    
    fileprivate func createStore(_ persistenceStoreCoordinator: NSPersistentStoreCoordinator, url: URL?, type: String = NSSQLiteStoreType) -> Error? {
        var error: Error?
        
        do {
            let options = [NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true]
            let _ = try persistenceStoreCoordinator.addPersistentStore(ofType: type, configurationName: nil, at: url, options: options)
        } catch let storeError {
            error = storeError
        }
        
        return error
    }
    
    fileprivate func destroyStore(_ persistentStoreCoordinator: NSPersistentStoreCoordinator, atURL URL: Foundation.URL, type: String = NSSQLiteStoreType) {
        do {
            let _ = try persistentStoreCoordinator.destroyPersistentStore(at: URL, ofType: type, options: nil)
        } catch { }
    }
}
