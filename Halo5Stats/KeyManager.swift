//
//  KeyManager.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation

final class KeyManager {

    static let sharedManager = KeyManager()

    var apiKey: String? {
        guard let info = NSBundle.mainBundle().infoDictionary else { return nil }
        guard let key = info["apiKey"] as? String else { return nil }
        return key
    }
}
