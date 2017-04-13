//
//  TeamColor.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit
import CoreData


class TeamColor: NSManagedObject {

    static func teamColor(forIdentifier id: Int) -> TeamColor? {
        guard let controller = Container.resolve(PersistenceController.self) else { return nil }
        let predicate = NSPredicate.predicate(withNumberIdentifier: NSNumber(integerLiteral: id))
        
        return TeamColor.findOrFetch(inContext: controller.managedObjectContext, matchingPredicate: predicate)
    }

}

extension TeamColor: ManagedObjectTypeProtocol {

    static var entityName: String {
        return "TeamColor"
    }

    static func parse(_ data: [String : AnyObject], context: NSManagedObjectContext) {
        guard let teamColors = data[JSONKeys.TeamColor.teamColors] as? [AnyObject] else { return }

        for color in teamColors {
            let identifier = color[JSONKeys.identifier] as? String
            guard let numberIdentifier = NSNumber(identifier: identifier) else {
                continue
            }

            let predicate = NSPredicate.predicate(withNumberIdentifier: numberIdentifier)

            TeamColor.findOrCreate(inContext: context, matchingPredicate: predicate) {
                $0.name = color[JSONKeys.name] as? String
                $0.overview = color[JSONKeys.overview] as? String
                $0.iconUrl = color[JSONKeys.iconUrl] as? String
                $0.color = color[JSONKeys.TeamColor.color] as? String
                $0.identifier = numberIdentifier
            }
        }
    }
}
