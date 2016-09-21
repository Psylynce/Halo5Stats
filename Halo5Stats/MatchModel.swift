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
    var gameTypeIconUrl: NSURL?
    var mapName: String
    var mapImageUrl: NSURL
    var outcome: Outcome?
    var score: String
    var date: NSDate
    var matchId: String
    var isTeamGame: Bool
    var teams: [TeamModel]
    var duration: String?

    enum Outcome: Int {
        case DNF = 0
        case Lost = 1
        case Tied = 2
        case Won = 3

        func text() -> String {
            switch self {
            case .DNF:
                return "DNF"
            case .Tied:
                return "T"
            case .Lost:
                return "L"
            case .Won:
                return "W"
            }
        }

        func color() -> UIColor {
            switch self {
            case .DNF:
                return UIColor.yellowColor()
            case .Lost:
                return UIColor.redColor()
            case .Tied:
                return UIColor.cyanColor()
            case .Won:
                return UIColor.greenColor()
            }
        }
    }

    static func convert(match: Match) -> MatchModel? {
        guard let gbvId = match.gameBaseVariantId, gameBaseVariant = GameBaseVariant.baseVariant(forIdentifier: gbvId), mapId = match.mapId, map = Map.map(forIdentifier: mapId), completionDate = match.completionDate, teamGameNum = match.isTeamGame else { return nil }
        guard let mapImageUrlString = map.imageUrl, mapImageUrl = NSURL(string: mapImageUrlString) else { return nil }

        let gameModeInt = Int(match.gameMode ?? -1)
        let gameMode = GameMode.gameMode(forInt: gameModeInt)
        let gameType = gameBaseVariant.name ?? ""
        let gameTypeIconUrl = NSURL(string: gameBaseVariant.iconUrl ?? "")
        let mapName = map.name ?? ""
        let intOutcome = Int(match.outcome ?? -1)
        let outcome = Outcome(rawValue: intOutcome)
        let score = match.score()
        let date = completionDate
        let matchId = match.identifier ?? ""
        let isTeamGame = Bool(teamGameNum.integerValue)
        let teams = TeamModel.teams(match)
        let durationTime = match.matchDuration ?? ""
        let duration = DurationFormatter.readableDuration(durationTime)

        let model = MatchModel(match: match, gameMode: gameMode, gameType: gameType, gameTypeIconUrl: gameTypeIconUrl, mapName: mapName, mapImageUrl: mapImageUrl, outcome: outcome, score: score, date: date, matchId: matchId, isTeamGame: isTeamGame, teams: teams, duration: duration)

        return model
    }
}
