//
//  OpponentDetailModel.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation

struct OpponentDetailModel {
    var gamertag: String
    var killCount: Int
    var emblemUrl: URL

    static func convert(_ opponent: OpponentDetail) -> OpponentDetailModel? {
        guard let gamertag = opponent.gamertag else { return nil }
        guard let killCount = opponent.killCount as? Int else { return nil }
        let emblemUrl = ProfileService.emblemUrl(forGamertag: gamertag)

        let model = OpponentDetailModel(gamertag: gamertag, killCount: killCount, emblemUrl: emblemUrl as URL)

        return model
    }

    static func displayItems(_ opponents: [OpponentDetailModel]) -> [DisplayItem] {
        return opponents.map { $0 as DisplayItem }
    }
}

extension OpponentDetailModel: DisplayItem {

    var title: String? {
        return gamertag
    }

    var number: String {
        return "\(killCount)"
    }

    var url: URL? {
        return emblemUrl
    }
}
