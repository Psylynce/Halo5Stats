//
//  Season+CoreDataProperties.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Season {

    @NSManaged var endDate: String?
    @NSManaged var iconUrl: String?
    @NSManaged var identifier: String?
    @NSManaged var isActive: NSNumber?
    @NSManaged var name: String?
    @NSManaged var startDate: String?
    @NSManaged var playlists: NSSet?

}
