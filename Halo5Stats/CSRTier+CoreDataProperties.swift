//
//  CSRTier+CoreDataProperties.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CSRTier {

    @NSManaged var iconImageUrl: String?
    @NSManaged var identifier: String?
    @NSManaged var designation: CSRDesignation?

}
