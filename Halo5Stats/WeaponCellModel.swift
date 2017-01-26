//
//  WeaponCellModel.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation

class WeaponCellModel: ScoreCollectionViewDataSource {

    let weapons: [WeaponModel]

    init(weapons: [WeaponModel]) {
        self.weapons = weapons
    }

    var type: ScoreCollectionViewCellType {
        return .weaponStats
    }

    var items: [DisplayItem] {
        return WeaponModel.displayItems(weapons)
    }
}
