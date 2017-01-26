//
//  WeaponsViewModel.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation

class WeaponsViewModel {

    fileprivate let allWeapons: [WeaponModel]
    var weapons: [WeaponModel]
    let gameMode: GameMode
    let imageManager = ImageManager()
    var selectedFilter: Dynamic<WeaponsFilterViewModel.FilterOption?> = Dynamic(nil)

    init(weapons: [WeaponModel], gameMode: GameMode) {
        let sortedWeapons = weapons.sorted { $0.name < $1.name }
        self.weapons = sortedWeapons
        self.allWeapons = sortedWeapons
        self.gameMode = gameMode
        imageManager.style = .large
    }

    func filterWeapons() {
        guard let filter = selectedFilter.value else { return }

        switch filter {
        case .all:
            weapons = allWeapons
        default:
            weapons = allWeapons.filter { $0.type == filter.weaponType }
        }
    }
}
