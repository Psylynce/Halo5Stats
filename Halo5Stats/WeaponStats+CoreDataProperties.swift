//
//  WeaponStats+CoreDataProperties.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension WeaponStats {

    @NSManaged var identifier: String?
    @NSManaged var attachments: String?
    @NSManaged var totalShotsFired: NSNumber?
    @NSManaged var totalShotsLanded: NSNumber?
    @NSManaged var totalKills: NSNumber?
    @NSManaged var totalHeadshots: NSNumber?
    @NSManaged var totalDamage: NSNumber?
    @NSManaged var totalPossessionTime: String?
    @NSManaged var serviceRecord: ServiceRecord?
    @NSManaged var mostUsedServiceRecord: ServiceRecord?
    @NSManaged var mostUsedCarnageReport: CarnageReport?
    @NSManaged var carnageReport: CarnageReport?

}
