//
//  Spartan+CoreDataProperties.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Spartan {

    @NSManaged var displayGamertag: String?
    @NSManaged var spartanImageUrl: String?
    @NSManaged var emblemImageUrl: String?
    @NSManaged var gamertag: String?
    @NSManaged var matches: NSSet?
    @NSManaged var serviceRecords: NSSet?

}
