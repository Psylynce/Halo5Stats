//
//  WeaponsViewModel.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation

class WeaponsViewModel {

    let weapons: [WeaponModel]
    let gameMode: GameMode
    let imageManager = ImageManager()

    init(weapons: [WeaponModel], gameMode: GameMode) {
        self.weapons = weapons.sort { $0.name < $1.name }
        self.gameMode = gameMode
        imageManager.style = .large
    }
}
