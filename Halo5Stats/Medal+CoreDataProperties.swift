//
//  Medal+CoreDataProperties.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Medal {

    @NSManaged var classification: String?
    @NSManaged var difficulty: NSNumber?
    @NSManaged var identifier: String?
    @NSManaged var name: String?
    @NSManaged var overview: String?
    @NSManaged var spriteLocationX: NSNumber?
    @NSManaged var spriteLocationY: NSNumber?
    @NSManaged var spriteWidth: NSNumber?
    @NSManaged var spriteHeight: NSNumber?
    @NSManaged var spriteImageUrl: String?
    @NSManaged var spriteSheetWidth: NSNumber?
    @NSManaged var spriteSheetHeight: NSNumber?

}
