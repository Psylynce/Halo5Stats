//
//  GameBaseVariant.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit
import CoreData


class GameBaseVariant: NSManagedObject {

    static func baseVariant(forIdentifier id: String) -> GameBaseVariant? {
        let predicate = NSPredicate.predicate(withIdentifier: id)
        return GameBaseVariant.findOrFetch(inContext: UIApplication.appController().managedObjectContext(), matchingPredicate: predicate)
    }

}

extension GameBaseVariant: ManagedObjectTypeProtocol {

    static var entityName: String {
        return "GameBaseVariant"
    }

    static func parse(_ data: [String : AnyObject], context: NSManagedObjectContext) {
        guard let variants = data[JSONKeys.GameBaseVariant.gameBaseVariants] as? [AnyObject] else { return }

        for variant in variants {
            guard let identifier = variant[JSONKeys.identifier] as? String else {
                print("No variant found")
                continue
            }

            let predicate = NSPredicate.predicate(withIdentifier: identifier)

            GameBaseVariant.findOrCreate(inContext: context, matchingPredicate: predicate) {
                $0.name = variant[JSONKeys.name] as? String
                $0.iconUrl = variant[JSONKeys.iconUrl] as? String
                $0.identifier = identifier

                if let supportedGameModes = variant[JSONKeys.GameBaseVariant.supportedGameModes] as? [String] {
                    $0.supportedGameModes = supportedGameModes.joined(separator: ",")
                }
            }
        }
    }
}
