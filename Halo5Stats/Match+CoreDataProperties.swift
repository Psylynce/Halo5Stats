//
//  Match+CoreDataProperties.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Match {

    @NSManaged var completionDate: Date?
    @NSManaged var gameBaseVariantId: String?
    @NSManaged var gameMode: NSNumber?
    @NSManaged var gameVariantId: String?
    @NSManaged var gameVariantOwnerType: NSNumber?
    @NSManaged var identifier: String?
    @NSManaged var isTeamGame: NSNumber?
    @NSManaged var mapId: String?
    @NSManaged var mapVariantId: String?
    @NSManaged var mapVariantOwnerType: NSNumber?
    @NSManaged var matchDuration: String?
    @NSManaged var matchPath: String?
    @NSManaged var outcome: NSNumber?
    @NSManaged var playlistId: String?
    @NSManaged var seasonId: String?
    @NSManaged var spartan: Spartan?
    @NSManaged var carnageReports: NSSet?
    @NSManaged var teams: NSSet?

}
