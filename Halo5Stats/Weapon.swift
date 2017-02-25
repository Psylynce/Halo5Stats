//
//  Weapon.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit
import CoreData


class Weapon: NSManagedObject {

    static func weapon(forIdentifier id: String) -> Weapon? {
        let context = UIApplication.appController().managedObjectContext()
        let predicate = NSPredicate.predicate(withIdentifier: id)
        guard let weapon = Weapon.findOrFetch(inContext: context, matchingPredicate: predicate) else { return nil }

        return weapon
    }

}

extension Weapon: ManagedObjectTypeProtocol {

    static var entityName: String {
        return "Weapon"
    }

    static func parse(_ data: [String : AnyObject], context: NSManagedObjectContext) {
        guard let weapons = data[JSONKeys.Weapon.weapons] as? [AnyObject] else { return }

        for weapon in weapons {
            guard let identifier = weapon[JSONKeys.identifier] as? String else { continue }
            let predicate = NSPredicate.predicate(withIdentifier: identifier)

            Weapon.findOrCreate(inContext: context, matchingPredicate: predicate) {
                $0.name = weapon[JSONKeys.name] as? String
                $0.overview = weapon[JSONKeys.overview] as? String
                $0.largeIconUrl = weapon[JSONKeys.Weapon.largeIconUrl] as? String
                $0.smallIconUrl = weapon[JSONKeys.Weapon.smallIconUrl] as? String
                $0.type = weapon[JSONKeys.Weapon.type] as? String
                $0.isUsableByPlayer = weapon[JSONKeys.Weapon.isUsable] as? Bool as NSNumber?
                $0.identifier = identifier
            }
        }
    }
}
