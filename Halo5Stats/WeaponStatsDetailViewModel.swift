//
//  WeaponStatsDetailViewModel.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation

class WeaponStatsDetailViewModel {

    let weapon: WeaponModel
    let imageManager: ImageManager

    init(weapon: WeaponModel, imageManager: ImageManager) {
        self.weapon = weapon
        self.imageManager = imageManager
    }
}
