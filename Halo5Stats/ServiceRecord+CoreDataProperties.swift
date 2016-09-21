//
//  ServiceRecord+CoreDataProperties.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ServiceRecord {

    @NSManaged var type: String?
    @NSManaged var totalGamesCompleted: NSNumber?
    @NSManaged var totalGamesWon: NSNumber?
    @NSManaged var totalGamesLost: NSNumber?
    @NSManaged var totalGamesTied: NSNumber?
    @NSManaged var totalTimePlayed: String?
    @NSManaged var gamertag: String?
    @NSManaged var highestCSRPlaylistId: String?
    @NSManaged var seasonId: String?
    @NSManaged var highestCSRSeasonId: String?
    @NSManaged var arenaPlaylistSeasonId: String?
    @NSManaged var resultCode: NSNumber?
    @NSManaged var spartanRank: NSNumber?
    @NSManaged var baseStats: BaseStats?
    @NSManaged var mostUsedWeapon: WeaponStats?
    @NSManaged var weaponStats: NSSet?
    @NSManaged var medalAwards: NSSet?
    @NSManaged var highestCSRAttained: AttainedCSR?
    @NSManaged var spartan: Spartan?

}
