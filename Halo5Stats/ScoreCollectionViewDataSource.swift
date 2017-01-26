//
//  ScoreCollectionViewDataSource.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

protocol ScoreCollectionViewDataSource {
    var type: ScoreCollectionViewCellType { get }
    var items: [DisplayItem] { get }
}

protocol DisplayItem {
    var title: String? { get }
    var number: String { get }
    var url: URL? { get }
}

enum ScoreCollectionViewCellType {
    case teamScore
    case playerScore
    case medals
    case enemyAIKills
    case vehicleKills
    case weaponStats
    case playerStats
}
