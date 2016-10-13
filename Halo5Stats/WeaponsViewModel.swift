//
//  WeaponsViewModel.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation

class WeaponsViewModel {

    let weapons: [WeaponModel]
    let imageManager = ImageManager()

    init(weapons: [WeaponModel]) {
        self.weapons = weapons.sort { $0.name < $1.name }
    }
}
