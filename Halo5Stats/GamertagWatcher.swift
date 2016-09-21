//
//  GamertagWatcher.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

@objc protocol GamertagWatcher {
    func defaultGamertagChanged(notification: NSNotification)
}

extension GamertagWatcher where Self: UIViewController {

    func addGamertagWatcher() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(defaultGamertagChanged(_:)), name: GamertagManager.K.notificationName, object: nil)
    }

    func removeGamertagWatcher() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
