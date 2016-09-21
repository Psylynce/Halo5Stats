//
//  PlayerStatsParentViewModel.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class PlayerStatsParentViewModel {

    let gamertag: String?
    var spartans: Dynamic<[SpartanModel]> = Dynamic([])

    init(gamertag: String?) {
        self.gamertag = gamertag
    }

    convenience init() {
        let gamertag = GamertagManager.sharedManager.gamertagForUser()

        self.init(gamertag: gamertag)
    }

    func spartan() -> Spartan? {
        guard let gamertag = gamertag, spartan = Spartan.spartan(gamertag) else { return nil }
        return spartan
    }

    func isDefaultUser() -> Bool {
        guard let defaultGamertag = GamertagManager.sharedManager.gamertagForUser(), gamertag = gamertag else { return false }

        return defaultGamertag == gamertag
    }
}
