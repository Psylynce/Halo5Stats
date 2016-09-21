//
//  CarnageReport+CoreDataProperties.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CarnageReport {

    @NSManaged var gamertag: String?
    @NSManaged var didNotFinish: NSNumber?
    @NSManaged var rank: NSNumber?
    @NSManaged var teamId: NSNumber?
    @NSManaged var averageLifeTime: String?
    @NSManaged var totalDuration: String?
    @NSManaged var mapVariantId: String?
    @NSManaged var gameVariantId: String?
    @NSManaged var playlistId: String?
    @NSManaged var mapId: String?
    @NSManaged var gameBaseVariantId: String?
    @NSManaged var seasonId: String?
    @NSManaged var baseStats: BaseStats?
    @NSManaged var mostUsedWeapon: WeaponStats?
    @NSManaged var weaponStats: NSSet?
    @NSManaged var match: Match?
    @NSManaged var aiKills: NSSet?
    @NSManaged var vehicleKills: NSSet?
    @NSManaged var medals: NSSet?
    @NSManaged var killedByOpponents: NSSet?
    @NSManaged var killedOpponents: NSSet?

}
