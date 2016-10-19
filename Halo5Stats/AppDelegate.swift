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
    
    private var _operationQueue: OperationQueue!
    private var _persistenceController: PersistenceController!
    private var _applicationViewController: ApplicationViewController!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let startupOperation = StartupOperation() {
            print("Startup Operation Completed")
            dispatch_async(dispatch_get_main_queue()) {
                self.window?.rootViewController = self.applicationViewController
            }
        }
        operationQueue.addOperation(startupOperation)

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        persistenceController.save()
    }

    func applicationDidEnterBackground(application: UIApplication) {
        persistenceController.save()
    }

    func applicationWillTerminate(application: UIApplication) {
        persistenceController.save()
    }
    
    // MARK: - AppControllerProtocol

    var applicationViewController: ApplicationViewController! {
        if _applicationViewController == nil {
            _applicationViewController = StoryboardScene.Main.initialViewController() as! ApplicationViewController
        }

        return _applicationViewController
    }
    
    var operationQueue: OperationQueue! {
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

