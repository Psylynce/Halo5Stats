//
//  BaseStats.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation
import CoreData


class BaseStats: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

}

extension BaseStats: ManagedObjectTypeProtocol {

    static var entityName: String {
        return "BaseStats"
    }

    static func parse(data: [String : AnyObject], context: NSManagedObjectContext) {
        // Need a custom parse method
    }

    func update(withData data: AnyObject, context: NSManagedObjectContext) {
        totalKills = data[JSONKeys.BaseStats.totalKills] as? Int
        totalDeaths = data[JSONKeys.BaseStats.totalDeaths] as? Int
        totalAssists = data[JSONKeys.BaseStats.totalAssists] as? Int
        totalGrenadeKills = data[JSONKeys.BaseStats.totalGrenadeKills] as? Int
        totalGrenadeDamage = data[JSONKeys.BaseStats.totalGrenadeDamage] as? Double
        totalAssassinations = data[JSONKeys.BaseStats.totalAssassinations] as? Int
        totalGroundPoundKills = data[JSONKeys.BaseStats.totalGroundPoundKills] as? Int
        totalGroundPoundDamage = data[JSONKeys.BaseStats.totalGroundPoundDamage] as? Double
        totalHeadshots = data[JSONKeys.BaseStats.totalHeadshots] as? Int
        totalMeleeKills = data[JSONKeys.BaseStats.totalMeleeKills] as? Int
        totalMeleeDamage = data[JSONKeys.BaseStats.totalMeleeDamage] as? Double
        totalPowerWeaponKills = data[JSONKeys.BaseStats.totalPowerWeaponKills] as? Int
        totalPowerWeaponDamage = data[JSONKeys.BaseStats.totalPowerWeaponDamage] as? Double
        totalPowerWeaponGrabs = data[JSONKeys.BaseStats.totalPowerWeaponGrabs] as? Int
        totalPowerWeaponPossessionTime = data[JSONKeys.BaseStats.totalPowerWeaponPossessionTime] as? String
        totalShotsFired = data[JSONKeys.BaseStats.totalShotsFired] as? Int
        totalShotsLanded = data[JSONKeys.BaseStats.totalShotsLanded] as? Int
        totalShoulderBashKills = data[JSONKeys.BaseStats.totalShoulderBashKills] as? Int
        totalShoulderBashDamage = data[JSONKeys.BaseStats.totalShoulderBashDamage] as? Double
        totalWeaponDamage = data[JSONKeys.BaseStats.totalWeaponDamage] as? Double
    }
}

