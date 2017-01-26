//
//  KeyManager.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation

final class KeyManager {

    static let sharedManager = KeyManager()

    struct K {
        static let fileName = "Keys"
        static let fileType = "plist"
        static let production = "production"
        static let development = "development"
    }

    var apiKey: String? {
        guard let path = Bundle.main.path(forResource: K.fileName, ofType: K.fileType) else { return nil }
        guard let keyInfo = NSDictionary(contentsOfFile: path) else { return nil }
        var keyString = K.production
        #if DEBUG
            keyString = K.development
        #endif
        guard let key = keyInfo[keyString] as? String else { return nil }
        return key
    }
}
