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

    func saveSpartan(_ gamertag: String) {
        guard spartanIsSaved(gamertag.lowercased()) == false else { return }

        var savedSpartans = self.savedSpartans()
        savedSpartans.append(gamertag.lowercased())

        UserDefaults.standard.setValue(savedSpartans, forKey: K.savedSpartansKey)
        UserDefaults.standard.synchronize()
    }

    func deleteSpartan(_ gamertag: String) {
        guard spartanIsSaved(gamertag.lowercased()) == true else { return }

        var savedSpartans = self.savedSpartans()
        guard let index = savedSpartans.index(of: gamertag.lowercased()) else { return }

        savedSpartans.remove(at: index)

        UserDefaults.standard.setValue(savedSpartans, forKey: K.savedSpartansKey)
        UserDefaults.standard.synchronize()
    }

    func spartanIsSaved(_ gamertag: String) -> Bool {
        let savedSpartans = self.savedSpartans()

        return savedSpartans.contains(gamertag.lowercased())
    }

    func savedSpartans() -> [String] {
        guard let spartans = UserDefaults.standard.array(forKey: K.savedSpartansKey) as? [String] else { return [] }
        return spartans
    }
}
