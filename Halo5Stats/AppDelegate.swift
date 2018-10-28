//
//  AppDelegate.swift
//  Halo5Stats
//
//  Copyright © 2015 Justin Powell. All rights reserved.
//

import UIKit

extension UIApplication {

    class var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    class var rootViewController: UIViewController {
        let delegate = UIApplication.appDelegate
        return delegate.applicationViewController
    }
}

@UIApplicationMain
class AppDelegate: UIResponder {

    var window: UIWindow?

    fileprivate(set) lazy var applicationViewController = StoryboardScene.Main.initialViewController() as! ApplicationViewController
}

extension AppDelegate: UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let startupManager = StartupManager()
        startupManager.delegate = self
        startupManager.startup()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        guard let controller = Container.resolve(PersistenceController.self) else { return }
        controller.save()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        guard let controller = Container.resolve(PersistenceController.self) else { return }
        controller.save()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        guard let controller = Container.resolve(PersistenceController.self) else { return }
        controller.save()
    }
}

extension AppDelegate: StartupManagerDelegate {

    func didFinishStartup() {
        self.window?.rootViewController = applicationViewController
    }
}
