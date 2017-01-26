//
//  AppDelegate.swift
//  Halo5Stats
//
//  Copyright © 2015 Justin Powell. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AppControllerProtocol {

    var window: UIWindow?
    
    fileprivate var _operationQueue: OperationQueue!
    fileprivate var _persistenceController: PersistenceController!
    fileprivate var _applicationViewController: ApplicationViewController!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let startupOperation = StartupOperation() {
            print("Startup Operation Completed")
            DispatchQueue.main.async {
                self.window?.rootViewController = self.applicationViewController
            }
        }
        operationQueue.addOperation(startupOperation)

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        persistenceController.save()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        persistenceController.save()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        persistenceController.save()
    }
    
    // MARK: - AppControllerProtocol

    var applicationViewController: ApplicationViewController {
        if _applicationViewController == nil {
            _applicationViewController = StoryboardScene.Main.initialViewController() as! ApplicationViewController
        }

        return _applicationViewController
    }
    
    var operationQueue: OperationQueue {
        if _operationQueue == nil {
            _operationQueue = OperationQueue()
        }
        
        return _operationQueue
    }
    
    var persistenceController: PersistenceController! {
        get {
            return _persistenceController
        }
        
        set (newController) {
            _persistenceController = newController
        }
    }
    
    func managedObjectContext() -> NSManagedObjectContext {
        return _persistenceController.managedObjectContext
    }
}

