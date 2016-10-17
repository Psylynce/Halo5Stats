//
//  WeaponModel.swift
//  Halo5Stats
//
//  Created by Justin Powell on 4/14/16.
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

struct WeaponModel {
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
    var smallIconUrl: NSURL
    var largeIconUrl: NSURL

    var accuracy: Double {
        return percentage()
    }

    static func convert(weapon: WeaponStats) -> WeaponModel? {
        guard let identifier = weapon.identifier else { return nil }
        guard let weaponData = Weapon.weapon(forIdentifier: identifier) else { return nil }
        guard let name = weaponData.name else { return nil }
        let overview = weaponData.overview
        guard let shotsFired = weapon.totalShotsFired as? Int else { return nil }
        guard let shotsLanded = weapon.totalShotsLanded as? Int else { return nil }
        guard let headshots = weapon.totalHeadshots as? Int else { return nil }
        guard let kills = weapon.totalKills as? Int else { return nil }
        guard let damage = weapon.totalDamage as? Double else { return nil }
        guard let smallUrlString = weaponData.smallIconUrl, smallUrl = NSURL(string: smallUrlString) else { return nil }
        guard let largeUrlString = weaponData.largeIconUrl, largeUrl = NSURL(string: largeUrlString) else { return nil }

        let model = WeaponModel(weapon: weaponData, name: name, overview: overview, weaponId: identifier, attachments: [], shotsFired: shotsFired, shotsLanded: shotsLanded, headshots: headshots, kills: kills, damageDealt: damage.roundedToTwo(), smallIconUrl: smallUrl, largeIconUrl: largeUrl)

        return model
    }

    static func displayItems(weapons: [WeaponModel]) -> [DisplayItem] {
        return weapons.sort{ $0.kills > $1.kills }.map { $0 as DisplayItem }
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

    func percentageDetails(gameMode: GameMode) -> [PercentageDetail] {
        return [(value: shotsFired, color: UIColor(haloColor: .Bismark)), (value: shotsLanded, color: gameMode.color)]
    }
}

extension WeaponModel: DisplayItem {

    var title: String? {
        return nil
    }

    var number: String {
        return "\(kills)_\(headshots)_\(accuracy)"
    }

    var url: NSURL? {
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

    var imageURL: NSURL {
        return smallIconUrl
    }

    var largeImageURL: NSURL? {
        return largeIconUrl
    }

    var placeholderImage: UIImage? {
        return UIImage(named: "Weapon")
    }
}
