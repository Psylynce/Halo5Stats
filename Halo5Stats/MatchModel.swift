//
//  MatchModel.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

struct MatchModel {
    var match: Match
    var gameMode: GameMode?
    var gameType: String
    var gameTypeIconUrl: URL?
    var mapName: String
    var mapImageUrl: URL
    var outcome: Outcome?
    var score: String
    var date: Date
    var matchId: String
    var isTeamGame: Bool
    var teams: [TeamModel]
    var duration: String?

    enum Outcome: Int {
        case dnf = 0
        case lost = 1
        case tied = 2
        case won = 3

        func text() -> String {
            switch self {
            case .dnf:
                return "DNF"
            case .tied:
                return "T"
            case .lost:
                return "L"
            case .won:
                return "W"
            }
        }

        func color() -> UIColor {
            switch self {
            case .dnf:
                return UIColor.yellow
            case .lost:
                return UIColor.red
            case .tied:
                return UIColor.cyan
            case .won:
                return UIColor.green
            }
        }
    }

    static func convert(_ match: Match) -> MatchModel? {
        guard let gbvId = match.gameBaseVariantId, let gameBaseVariant = GameBaseVariant.baseVariant(forIdentifier: gbvId), let mapId = match.mapId, let map = Map.map(forIdentifier: mapId), let completionDate = match.completionDate, let teamGameNum = match.isTeamGame else { return nil }
        guard let mapImageUrlString = map.imageUrl, let mapImageUrl = URL(string: mapImageUrlString) else { return nil }

        let gameModeInt = Int(truncating: match.gameMode ?? -1)
        let gameMode = GameMode.gameMode(forInt: gameModeInt)
        let gameType = gameBaseVariant.name ?? ""
        let gameTypeIconUrl = URL(string: gameBaseVariant.iconUrl ?? "")
        let mapName = map.name ?? ""
        let intOutcome = Int(truncating: match.outcome ?? -1)
        let outcome = Outcome(rawValue: intOutcome)
        let score = match.score()
        let date = completionDate
        let matchId = match.identifier ?? ""
        let isTeamGame = Bool(truncating: teamGameNum.intValue as NSNumber)
        let teams = TeamModel.teams(match)
        let durationTime = match.matchDuration ?? ""
        let duration = DurationFormatter.readableDuration(durationTime)

        let model = MatchModel(match: match, gameMode: gameMode, gameType: gameType, gameTypeIconUrl: gameTypeIconUrl, mapName: mapName, mapImageUrl: mapImageUrl, outcome: outcome, score: score, date: date, matchId: matchId, isTeamGame: isTeamGame, teams: teams, duration: duration)

        return model
    }
}
