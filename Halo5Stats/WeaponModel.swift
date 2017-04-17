//
//  WeaponModel.swift
//  Halo5Stats
//
//  Created by Justin Powell on 4/14/16.
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

struct WeaponModel {

    enum WeaponType {
        case grenade
        case turret
        case vehicle
        case standard
        case power
        case unknown

        var color: UIColor {
            switch self {
            case .grenade:
                return .grenades
            case .turret:
                return .turrets
            case .vehicle:
                return .vehicles
            case .standard:
                return .standardWeapons
            case .power:
                return .powerWeapons
            case .unknown:
                return .unknown
            }
        }

        var image: UIImage {
            switch self {
            case .grenade:
                return UIImage(named: "grenades")!
            case .turret:
                return UIImage(named: "turrets")!
            case .vehicle:
                return UIImage(named: "vehicles")!
            case .standard:
                return UIImage(named: "standardWeapons")!
            case .power:
                return UIImage(named: "powerWeapons")!
            case .unknown:
                return UIImage(named: "unknown")!
            }
        }
    }

    var weapon: Weapon?
    var name: String
    var overview: String?
    var weaponId: String
    var attachments: [Int]
    var shotsFired: Int
    var shotsLanded: Int
    var headshots: Int
    var kills: Int
    var damageDealt: Double
    var smallIconUrl: URL
    var largeIconUrl: URL

    var accuracy: Double {
        return percentage()
    }

    var type: WeaponType {
        guard let typeString = weapon?.type?.lowercased() else { return .unknown }

        switch typeString {
        case "grenade":
            return .grenade
        case "turret":
            return .turret
        case "vehicle":
            return .vehicle
        case "standard":
            return .standard
        case "power":
            return .power
        default:
            return .unknown
        }
    }

    static func convert(_ weapon: WeaponStats) -> WeaponModel? {
        guard let identifier = weapon.identifier else { return nil }
        guard let weaponData = Weapon.weapon(forIdentifier: identifier) else { return nil }
        guard let name = weaponData.name else { return nil }
        let overview = weaponData.overview
        guard let shotsFired = weapon.totalShotsFired as? Int else { return nil }
        guard let shotsLanded = weapon.totalShotsLanded as? Int else { return nil }
        guard let headshots = weapon.totalHeadshots as? Int else { return nil }
        guard let kills = weapon.totalKills as? Int else { return nil }
        guard let damage = weapon.totalDamage as? Double else { return nil }
        guard let smallUrlString = weaponData.smallIconUrl, let smallUrl = URL(string: smallUrlString) else { return nil }
        guard let largeUrlString = weaponData.largeIconUrl, let largeUrl = URL(string: largeUrlString) else { return nil }

        let model = WeaponModel(weapon: weaponData, name: name, overview: overview, weaponId: identifier, attachments: [], shotsFired: shotsFired, shotsLanded: shotsLanded, headshots: headshots, kills: kills, damageDealt: damage.roundedToTwo(), smallIconUrl: smallUrl, largeIconUrl: largeUrl)

        return model
    }

    static func displayItems(_ weapons: [WeaponModel]) -> [DisplayItem] {
        return weapons.sorted{ $0.kills > $1.kills }.map { $0 as DisplayItem }
    }

    func percentage() -> Double {
        if shotsFired == 0 && shotsLanded == 0 {
            return 0
        }

        let doubleFired = Double(shotsFired)
        let doubleLanded = Double(shotsLanded)
        let percentage = doubleLanded / doubleFired * 100

        return percentage.roundedToTwo()
    }

    func percentageDetails(_ gameMode: GameMode) -> [PercentageDetail] {
        return [(value: shotsFired, color: .bismark), (value: shotsLanded, color: gameMode.color)]
    }
}

extension WeaponModel: DisplayItem {

    var title: String? {
        return nil
    }

    var number: String {
        return "\(kills)_\(headshots)_\(accuracy)"
    }

    var url: URL? {
        return smallIconUrl
    }
}

extension WeaponModel: CacheableImageModel {

    var typeIdentifier: String {
        return "Weapon"
    }

    var cacheIdentifier: String {
        return weaponId
    }

    var imageURL: URL {
        return smallIconUrl
    }

    var largeImageURL: URL? {
        return largeIconUrl
    }

    var placeholderImage: UIImage? {
        return UIImage(named: "Weapon")
    }
}
