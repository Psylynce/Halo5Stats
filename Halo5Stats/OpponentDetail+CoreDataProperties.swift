//
//  OpponentDetail+CoreDataProperties.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension OpponentDetail {

    @NSManaged var gamertag: String?
    @NSManaged var emblemUrl: String?
    @NSManaged var killCount: NSNumber?
    @NSManaged var killedCarnageReport: CarnageReport?
    @NSManaged var killedByCarnageReport: CarnageReport?

}
