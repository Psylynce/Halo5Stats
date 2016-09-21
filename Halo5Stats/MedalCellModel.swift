//
//  MedalCellModel.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation

class MedalCellModel: ScoreCollectionViewDataSource {

    let medals: [MedalModel]

    init(medals: [MedalModel]) {
        self.medals = medals
    }

    var type: ScoreCollectionViewCellType {
        return .Medals
    }

    var items: [DisplayItem] {
        return MedalModel.displayItems(medals)
    }
}
