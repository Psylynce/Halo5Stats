//
//  MedalModel.swift
//  Halo5Stats
//
//  Created by Justin Powell on 4/14/16.
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation

struct MedalModel {
    var medalId: String
    var count: Int
    var name: String
    var description: String
    var difficulty: Int
    var classification: String
    var imageUrl: NSURL
    var xPosition: Int
    var yPosition: Int
    var width: Int
    var height: Int
    var cacheIdentifier: String

    static func convert(medalAward: MedalAward) -> MedalModel? {
        guard let id = medalAward.medalIdentifier else { return nil }
        guard let count = medalAward.count as? Int else { return nil }
        guard let medal = Medal.medal(forIdentifier: id) else { return nil }
        guard let name = medal.name else { return nil }
        guard let description = medal.overview else { return nil }
        guard let difficulty = medal.difficulty as? Int else { return nil }
        guard let classification = medal.classification else { return nil }
        guard let imageUrl = medal.spriteImageUrl, url = NSURL(string: imageUrl) else { return nil }
        guard let xPosition = medal.spriteLocationX as? Int else { return nil }
        guard let yPosition = medal.spriteLocationY as? Int else { return nil }
        guard let width = medal.spriteWidth as? Int else { return nil }
        guard let height = medal.spriteHeight as? Int else { return nil }

        let updatedName = name.stringByReplacingOccurrencesOfString(" ", withString: "_")
        let cacheIdentifier = "\(updatedName)_\(xPosition)_\(yPosition)"

        let model = MedalModel(medalId: id, count: count, name: name, description: description, difficulty: difficulty, classification: classification, imageUrl: url, xPosition: xPosition, yPosition: yPosition, width: width, height: height, cacheIdentifier: cacheIdentifier)

        return model
    }

    static func displayItems(medals: [MedalModel]) -> [DisplayItem] {
        return medals.map { $0 as DisplayItem }
    }
}

extension MedalModel: DisplayItem {

    var title: String? {
        return name
    }

    var number: String {
        return "\(count)"
    }

    var url: NSURL? {
        return imageUrl
    }
}
