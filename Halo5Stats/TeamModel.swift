//
//  TeamModel.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation

struct TeamModel {
    var rank: Int
    var score: Int
    var identifier: Int
    var teamColor: TeamColor?

    static func teams(match: Match) -> [TeamModel] {
        guard let teams = match.teams?.allObjects as? [Team] else { return [] }

        var models: [TeamModel] = []

        for team in teams {
            if let model = TeamModel.convert(team) {
                models.append(model)
            }
        }

        return models.sort { $0.rank < $1.rank }
    }

    static func convert(team: Team) -> TeamModel? {
        guard let rank = team.rank as? Int, score = team.score as? Int, identifier = team.identifier as? Int else { return nil }

        let teamColor = TeamColor.teamColor(forIdentifier: identifier)

        return TeamModel(rank: rank, score: score, identifier: identifier, teamColor: teamColor)
    }

    static func displayItems(teams: [TeamModel]) -> [DisplayItem] {
        return teams.map { $0 as DisplayItem }
    }
}

extension TeamModel: DisplayItem {

    var title: String? {
        return nil
    }

    var number: String {
        return "\(score)"
    }

    var url: NSURL? {
        guard let teamDetail = teamColor, urlString = teamDetail.iconUrl else { return nil }

        return NSURL(string: urlString)
    }
}
