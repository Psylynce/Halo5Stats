//
//  WeaponsFilterViewModel.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation

class WeaponsFilterViewModel {

    enum FilterOption: String {
        case all = "All Weapons"
        case standard = "Standard Weapons"
        case power = "Power Weapons"
        case vehicle = "Vehicles"
        case grenade = "Grenades"
        case turret = "Turrets"
        case unknown = "Other Weapons"

        var weaponType: WeaponModel.WeaponType {
            switch self {
            case .all:
                return .unknown
            case .standard:
                return .standard
            case .power:
                return .power
            case .vehicle:
                return .vehicle
            case .grenade:
                return .grenade
            case .turret:
                return .turret
            case .unknown:
                return .unknown
            }
        }
    }

    var options: [FilterOption] = [.all, .standard, .power, .vehicle, .grenade, .turret, .unknown]
    var selectedOption: Dynamic<FilterOption> = Dynamic(.all)
}
