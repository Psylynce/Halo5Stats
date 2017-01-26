//
//  CarnageReportScoreCellModel.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation

class CarnageReportScoreCellModel: ScoreCollectionViewDataSource {

    let match: MatchModel
    let teams: [TeamModel]
    var players: [MatchPlayerModel]

    init(match: MatchModel, teams: [TeamModel], players: [MatchPlayerModel]) {
        self.match = match
        self.teams = teams
        self.players = players
    }

    func showTeam() -> Bool {
        let showTeam = match.isTeamGame
        return showTeam
    }

    var type: ScoreCollectionViewCellType {
        if showTeam() {
            return ScoreCollectionViewCellType.teamScore
        }
        return ScoreCollectionViewCellType.playerScore
    }

    var items: [DisplayItem] {
        if showTeam() {
            return TeamModel.displayItems(teams)
        }
        return MatchPlayerModel.displayItems(players)
    }
}
