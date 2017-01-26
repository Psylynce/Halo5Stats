//
//  GamertagWatcher.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

@objc protocol GamertagWatcher {
    func defaultGamertagChanged(_ notification: Notification)
}

extension GamertagWatcher where Self: UIViewController {

    func addGamertagWatcher() {
        NotificationCenter.default.addObserver(self, selector: #selector(defaultGamertagChanged(_:)), name: NSNotification.Name(rawValue: GamertagManager.K.notificationName), object: nil)
    }

    func removeGamertagWatcher() {
        NotificationCenter.default.removeObserver(self)
    }
}
