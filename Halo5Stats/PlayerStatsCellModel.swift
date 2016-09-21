//
//  PlayerStatsCellModel.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class PlayerStatsCellModel: ScoreCollectionViewDataSource {

    let stats: StatsModel

    init(stats: StatsModel) {
        self.stats = stats
    }

    var type: ScoreCollectionViewCellType {
        return .PlayerStats
    }

    var items: [DisplayItem] {
        return stats.statDisplayItems()
    }
}
