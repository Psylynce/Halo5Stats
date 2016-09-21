//
//  SpartanManager.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class SpartanManager {

    static let sharedManager = SpartanManager()

    struct K {
        static let savedSpartansKey = "savedSpartans"
    }

    func saveSpartan(gamertag: String) {
        guard spartanIsSaved(gamertag.lowercaseString) == false else { return }

        var savedSpartans = self.savedSpartans()
        savedSpartans.append(gamertag.lowercaseString)

        NSUserDefaults.standardUserDefaults().setValue(savedSpartans, forKey: K.savedSpartansKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    func spartanIsSaved(gamertag: String) -> Bool {
        let savedSpartans = self.savedSpartans()

        return savedSpartans.contains(gamertag.lowercaseString)
    }

    func savedSpartans() -> [String] {
        guard let spartans = NSUserDefaults.standardUserDefaults().arrayForKey(K.savedSpartansKey) as? [String] else { return [] }
        return spartans
    }
}
