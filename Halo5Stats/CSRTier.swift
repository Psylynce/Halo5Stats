//
//  CSRTier.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit
import CoreData


class CSRTier: NSManagedObject {

}

extension CSRTier: ManagedObjectTypeProtocol {

    static var entityName: String {
        return "CSRTier"
    }

    static func parse(_ data: [String : AnyObject], context: NSManagedObjectContext) {
        // Creating the tiers is done in the CSRDesignation parse method
    }
}
