//
//  AttainedCSR.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation
import CoreData


class AttainedCSR: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

}

extension AttainedCSR: ManagedObjectTypeProtocol {

    static var entityName: String {
        return "AttainedCSR"
    }

    func update(withData data: AnyObject, context: NSManagedObjectContext) {
        csr = data[JSONKeys.AttainedCSR.csr] as? Int
        designationId = data[JSONKeys.AttainedCSR.designationId] as? Int
        percentToNextTier = data[JSONKeys.AttainedCSR.percentToNextTier] as? Int
        rank = data[JSONKeys.AttainedCSR.rank] as? Int
        tier = data[JSONKeys.AttainedCSR.tier] as? Int
    }
}
