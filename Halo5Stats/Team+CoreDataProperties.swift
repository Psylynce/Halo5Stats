//
//  Team+CoreDataProperties.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Team {

    @NSManaged var identifier: NSNumber?
    @NSManaged var rank: NSNumber?
    @NSManaged var score: NSNumber?
    @NSManaged var match: Match?

}
