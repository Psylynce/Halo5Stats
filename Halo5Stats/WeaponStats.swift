//
//  WeaponStats.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit
import CoreData


class WeaponStats: NSManagedObject {

}

extension WeaponStats: ManagedObjectTypeProtocol {

    static var entityName: String {
        return "WeaponStats"
    }

    static func parse(_ data: [String : AnyObject], context: NSManagedObjectContext) {

    }

    func update(withData data: AnyObject, context: NSManagedObjectContext) {
        if let weaponId = data[JSONKeys.WeaponStats.weaponId] as? [String : AnyObject] {
            if let numIdentifier = weaponId[JSONKeys.WeaponStats.identifier] as? UInt {
                identifier = "\(numIdentifier)"
            }
            let attach = weaponId[JSONKeys.WeaponStats.attachments] as? [String]
            attachments = attach?.joined(separator: ",")
        }
        totalShotsFired = data[JSONKeys.WeaponStats.totalShotsFired] as? Int as NSNumber?
        totalShotsLanded = data[JSONKeys.WeaponStats.totalShotsLanded] as? Int as NSNumber?
        totalHeadshots = data[JSONKeys.WeaponStats.totalHeadshots] as? Int as NSNumber?
        totalKills = data[JSONKeys.WeaponStats.totalKills] as? Int as NSNumber?
        totalDamage = data[JSONKeys.WeaponStats.totalDamage] as? Double as NSNumber?
        totalPossessionTime = data[JSONKeys.WeaponStats.totalPossessionTime] as? String
    }
}

