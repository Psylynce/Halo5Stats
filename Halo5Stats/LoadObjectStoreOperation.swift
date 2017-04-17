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
        if let controller = Container.resolve(PersistenceController.self), controller.persistentStoreExists {
            finish()

            return
        }

        guard let persistence = PersistenceController(), persistence.persistentStoreExists else {
            let error = NSError(domain: "com.Halo5Stats.operations", code: 0, userInfo: [NSLocalizedDescriptionKey : "Could not initialize the Core Data store."])
            finishWithError(error as Error)

            return
        }

        Container.register(PersistenceController.self) { _ in persistence }
        finish()
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
}
