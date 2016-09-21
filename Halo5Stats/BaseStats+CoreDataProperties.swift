//
//  BaseStats+CoreDataProperties.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension BaseStats {

    @NSManaged var totalKills: NSNumber?
    @NSManaged var totalDeaths: NSNumber?
    @NSManaged var totalAssists: NSNumber?
    @NSManaged var totalHeadshots: NSNumber?
    @NSManaged var totalShotsFired: NSNumber?
    @NSManaged var totalShotsLanded: NSNumber?
    @NSManaged var totalWeaponDamage: NSNumber?
    @NSManaged var totalMeleeKills: NSNumber?
    @NSManaged var totalMeleeDamage: NSNumber?
    @NSManaged var totalAssassinations: NSNumber?
    @NSManaged var totalGroundPoundKills: NSNumber?
    @NSManaged var totalGroundPoundDamage: NSNumber?
    @NSManaged var totalShoulderBashKills: NSNumber?
    @NSManaged var totalShoulderBashDamage: NSNumber?
    @NSManaged var totalGrenadeKills: NSNumber?
    @NSManaged var totalGrenadeDamage: NSNumber?
    @NSManaged var totalPowerWeaponKills: NSNumber?
    @NSManaged var totalPowerWeaponDamage: NSNumber?
    @NSManaged var totalPowerWeaponGrabs: NSNumber?
    @NSManaged var totalPowerWeaponPossessionTime: String?
    @NSManaged var serviceRecord: ServiceRecord?
    @NSManaged var carnageReport: CarnageReport?

}
