//
//  Team.swift
//  Halo5Stats
//
//  Created by Justin Powell on 4/16/16.
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation
import CoreData


class Team: NSManagedObject {

    static func teams(fromData data: AnyObject, context: NSManagedObjectContext) -> [Team] {
        var teams: [Team] = []

        if let dataTeams = data[JSONKeys.Matches.teams] as? [AnyObject] {
            for team in dataTeams {
                let newTeam: Team = context.insertObject()
                newTeam.update(withData: team, context: context)
                teams.append(newTeam)
            }
        }

        return teams
    }

}

extension Team: ManagedObjectTypeProtocol {

    static var entityName: String {
        return "Team"
    }

    func update(withData data: AnyObject, context: NSManagedObjectContext) {
        identifier = data[JSONKeys.Identifier] as? Int as NSNumber?
        rank = data[JSONKeys.Matches.rank] as? Int as NSNumber?
        score = data[JSONKeys.Matches.score] as? Int as NSNumber?
    }
}
