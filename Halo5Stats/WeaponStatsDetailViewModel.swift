//
//  WeaponStatsDetailViewModel.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation

class WeaponStatsDetailViewModel {

    let weapon: WeaponModel
    let gameMode: GameMode
    let imageManager: ImageManager

    init(weapon: WeaponModel, gameMode: GameMode, imageManager: ImageManager) {
        self.weapon = weapon
        self.gameMode = gameMode
        self.imageManager = imageManager
    }
}
