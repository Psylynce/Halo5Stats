//
//  Map.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit
import CoreData


class Map: NSManagedObject {

    static func map(forIdentifier id: String) -> Map? {
        let predicate = NSPredicate.predicate(withIdentifier: id)
        return Map.findOrFetch(inContext: UIApplication.appController().managedObjectContext(), matchingPredicate: predicate)
    }

}

extension Map: ManagedObjectTypeProtocol {

    static var entityName: String {
        return "Map"
    }

    static func parse(_ data: [String : AnyObject], context: NSManagedObjectContext) {
        guard let maps = data[JSONKeys.Map.maps] as? [AnyObject] else { return }

        for mapData in maps {
            guard let identifier = mapData[JSONKeys.identifier] as? String else {
                print("No identifier for Map")
                continue
            }
            
            let predicate = NSPredicate.predicate(withIdentifier: identifier)
            Map.findOrCreate(inContext: context, matchingPredicate: predicate) {
                $0.name = mapData[JSONKeys.name] as? String
                $0.overview = mapData[JSONKeys.overview] as? String
                $0.imageUrl = mapData[JSONKeys.imageUrl] as? String
                $0.identifier = mapData[JSONKeys.identifier] as? String

                if let supportedGameModes = mapData[JSONKeys.Map.supportArray] as? [String] {
                    $0.supportedGameModes = supportedGameModes.joined(separator: ",")
                }
            }
        }
    }
}
