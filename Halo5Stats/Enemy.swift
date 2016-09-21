//
//  Enemy.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation
import CoreData


class Enemy: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

}

extension Enemy: ManagedObjectTypeProtocol {

    static var entityName: String {
        return "Enemy"
    }

    static func parse(data: [String : AnyObject], context: NSManagedObjectContext) {
        guard let enemies = data[JSONKeys.Enemy.enemies] as? [AnyObject] else { return }

        for enemy in enemies {
            guard let identifier = enemy[JSONKeys.identifier] as? String else { continue }
            let predicate = NSPredicate.predicate(withIdentifier: identifier)
            
            Enemy.findOrCreate(inContext: context, matchingPredicate: predicate) { 
                $0.name = enemy[JSONKeys.name] as? String
                $0.faction = enemy[JSONKeys.Enemy.faction] as? String
                $0.overview = enemy[JSONKeys.overview] as? String
                $0.largeIconImageUrl = enemy[JSONKeys.Enemy.largeIconUrl] as? String
                $0.smallIconUrl = enemy[JSONKeys.Enemy.smallIconUrl] as? String
                $0.identifier = identifier
            }
        }
    }
}
