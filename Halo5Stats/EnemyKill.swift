//
//  EnemyKill.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation
import CoreData


class EnemyKill: NSManagedObject {

}

extension EnemyKill: ManagedObjectTypeProtocol {

    static var entityName: String {
        return "EnemyKill"
    }

    func update(withData data: AnyObject, context: NSManagedObjectContext) {
        if let enemy = data[JSONKeys.EnemyKill.enemy] as? [String : AnyObject] {
            if let numIdentifier = enemy[JSONKeys.EnemyKill.id] as? UInt {
                identifier = "\(numIdentifier)"
            }
            if let a = enemy[JSONKeys.EnemyKill.attachments] as? [Int] {
                let stringA = a.map { String($0) }
                attachments = stringA.joined(separator: ",")
            }
        }
        totalKills = data[JSONKeys.EnemyKill.totalKills] as? Int as NSNumber?
    }
}
