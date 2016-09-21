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
    var url: NSURL? { get }
}

enum ScoreCollectionViewCellType {
    case TeamScore
    case PlayerScore
    case Medals
    case EnemyAIKills
    case VehicleKills
    case WeaponStats
    case PlayerStats
}
