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

    static func teams(_ match: Match) -> [TeamModel] {
        guard let teams = match.teams?.allObjects as? [Team] else { return [] }
        let models = teams.compactMap { TeamModel.convert($0) }

        return models.sorted { $0.rank < $1.rank }
    }

    static func convert(_ team: Team) -> TeamModel? {
        guard let rank = team.rank as? Int, let score = team.score as? Int, let identifier = team.identifier as? Int else { return nil }

        let teamColor = TeamColor.teamColor(forIdentifier: identifier)

        return TeamModel(rank: rank, score: score, identifier: identifier, teamColor: teamColor)
    }

    static func displayItems(_ teams: [TeamModel]) -> [DisplayItem] {
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

    var url: URL? {
        guard let teamDetail = teamColor, let urlString = teamDetail.iconUrl else { return nil }

        return URL(string: urlString)
    }
}
