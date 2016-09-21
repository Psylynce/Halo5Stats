//
//  Vehicle.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation
import CoreData


class Vehicle: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

}

extension Vehicle: ManagedObjectTypeProtocol {

    static var entityName: String {
        return "Vehicle"
    }

    static func parse(data: [String : AnyObject], context: NSManagedObjectContext) {
        guard let vehicles = data[JSONKeys.Vehicle.vehicles] as? [AnyObject] else { return }

        for vehicle in vehicles {
            guard let identifier = vehicle[JSONKeys.identifier] as? String else { continue }
            let predicate = NSPredicate.predicate(withIdentifier: identifier)

            Vehicle.findOrCreate(inContext: context, matchingPredicate: predicate) {
                $0.name = vehicle[JSONKeys.name] as? String
                $0.overview = vehicle[JSONKeys.overview] as? String
                $0.largeIconUrl = vehicle[JSONKeys.Vehicle.largeIconUrl] as? String
                $0.smallIconUrl = vehicle[JSONKeys.Vehicle.smallIconUrl] as? String
                $0.isUsableByPlayer = vehicle[JSONKeys.Vehicle.isUsable] as? Bool
                $0.identifier = identifier
            }
        }
    }
}
