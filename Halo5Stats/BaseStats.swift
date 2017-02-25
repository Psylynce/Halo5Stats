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

    static func parse(_ data: [String : AnyObject], context: NSManagedObjectContext) {
        // Need a custom parse method
    }

    func update(withData data: AnyObject, context: NSManagedObjectContext) {
        totalKills = data[JSONKeys.BaseStats.totalKills] as? Int as NSNumber?
        totalDeaths = data[JSONKeys.BaseStats.totalDeaths] as? Int as NSNumber?
        totalAssists = data[JSONKeys.BaseStats.totalAssists] as? Int as NSNumber?
        totalGrenadeKills = data[JSONKeys.BaseStats.totalGrenadeKills] as? Int as NSNumber?
        totalGrenadeDamage = data[JSONKeys.BaseStats.totalGrenadeDamage] as? Double as NSNumber?
        totalAssassinations = data[JSONKeys.BaseStats.totalAssassinations] as? Int as NSNumber?
        totalGroundPoundKills = data[JSONKeys.BaseStats.totalGroundPoundKills] as? Int as NSNumber?
        totalGroundPoundDamage = data[JSONKeys.BaseStats.totalGroundPoundDamage] as? Double as NSNumber?
        totalHeadshots = data[JSONKeys.BaseStats.totalHeadshots] as? Int as NSNumber?
        totalMeleeKills = data[JSONKeys.BaseStats.totalMeleeKills] as? Int as NSNumber?
        totalMeleeDamage = data[JSONKeys.BaseStats.totalMeleeDamage] as? Double as NSNumber?
        totalPowerWeaponKills = data[JSONKeys.BaseStats.totalPowerWeaponKills] as? Int as NSNumber?
        totalPowerWeaponDamage = data[JSONKeys.BaseStats.totalPowerWeaponDamage] as? Double as NSNumber?
        totalPowerWeaponGrabs = data[JSONKeys.BaseStats.totalPowerWeaponGrabs] as? Int as NSNumber?
        totalPowerWeaponPossessionTime = data[JSONKeys.BaseStats.totalPowerWeaponPossessionTime] as? String
        totalShotsFired = data[JSONKeys.BaseStats.totalShotsFired] as? Int as NSNumber?
        totalShotsLanded = data[JSONKeys.BaseStats.totalShotsLanded] as? Int as NSNumber?
        totalShoulderBashKills = data[JSONKeys.BaseStats.totalShoulderBashKills] as? Int as NSNumber?
        totalShoulderBashDamage = data[JSONKeys.BaseStats.totalShoulderBashDamage] as? Double as NSNumber?
        totalWeaponDamage = data[JSONKeys.BaseStats.totalWeaponDamage] as? Double as NSNumber?
    }
}

