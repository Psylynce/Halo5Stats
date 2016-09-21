//
//  SpartanModel.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation

struct SpartanModel {
    var spartan: Spartan
    var gamertag: String
    var displayGamertag: String
    var emblemUrl: NSURL
    var spartanImageUrl: NSURL

    static func convert(spartan: Spartan) -> SpartanModel? {
        guard let gamertag = spartan.gamertag else { return nil }
        guard let displayGamertag = spartan.displayGamertag else { return nil }

        let url = ProfileService.emblemUrl(forGamertag: gamertag)
        let spartanUrl = ProfileService.spartanImageUrl(forGamertag: gamertag)

        let model = SpartanModel(spartan: spartan, gamertag: gamertag, displayGamertag: displayGamertag, emblemUrl: url, spartanImageUrl: spartanUrl)

        return model
    }

    var isDefault: Bool {
        guard let defaultGt = GamertagManager.sharedManager.gamertagForUser() else { return false }

        return defaultGt == gamertag
    }
}
