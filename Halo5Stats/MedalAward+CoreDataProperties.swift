//
//  MedalAward+CoreDataProperties.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MedalAward {

    @NSManaged var medalIdentifier: String?
    @NSManaged var count: NSNumber?
    @NSManaged var carnageReport: CarnageReport?
    @NSManaged var serviceRecord: ServiceRecord?

}
