//
//  Match.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation
import CoreData


class Match: NSManagedObject {

    func carnageReport(forGamertag gamertag: String) -> CarnageReport? {
        guard let carnageReports = carnageReports?.allObjects as? [CarnageReport] else { return nil }

        for report in carnageReports {
            if let gt = report.gamertag, gt == gamertag {
                return report
            }
        }

        return nil
    }

    func score() -> String {
        guard let teams = teams?.allObjects as? [Team] else { return "" }

        var scores: [Int] = []
        for team in teams {
            guard let score = team.score as? Int else { continue }
            scores.append(score)
        }

        scores.sort { $0 > $1 }
        let stringScores = scores.map { String($0) }
        let finalString = stringScores.count > 4 ? stringScores[0] : stringScores.joined(separator: "-")

        return finalString
    }

    static func match(forIdentifier id: String, context: NSManagedObjectContext) -> Match? {
        let predicate = NSPredicate.predicate(withIdentifier: id)
        guard let match = Match.findOrFetch(inContext: context, matchingPredicate: predicate) else { return nil }

        return match
    }

    static func matches(forIdentifiers identifiers: [String], context: NSManagedObjectContext) -> [Match] {
        let predicate = NSPredicate(format: "identifier IN %@", identifiers)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Match.entityName)
        request.predicate = predicate

        do {
            let results = try context.fetch(request)
            guard let matches = results as? [Match] else { return [] }
            return matches
        }
        catch {
            print("Could not fetch matches")
            return []
        }
    }

    static func fixedPath(_ path: String) -> String {
        return path.replacingOccurrences(of: "h5/", with: "")
    }

    static func matches(forData data: [String : AnyObject]) -> [AnyObject]? {
        guard let matches = data[JSONKeys.Matches.matches] as? [AnyObject] else {
            return nil
        }

        return matches
    }

    static func parse(forGamertag gamertag: String, data: [String : AnyObject], context: NSManagedObjectContext) {
        let predicate = NSPredicate.predicate(withGamertag: gamertag)
        guard let matches = Match.matches(forData: data) else {
            print("No matches found for \(gamertag)")
            return
        }

        for match in matches {
            guard let identifier = match[JSONKeys.Identifier] as? [String : AnyObject], let mId = identifier[JSONKeys.Matches.matchId] as? String else {
                print("No Identifier Found")
                continue
            }

            if let spartan = Spartan.findOrFetch(inContext: context, matchingPredicate: predicate) {
                spartan.setDisplayGamertag(fromMatch: match)
            }

            if Match.match(forIdentifier: mId, context: context) == nil {
                let newMatch: Match = context.insertObject()
                newMatch.update(withData: match, context: context)
            }
        }
    }
}

extension Match: ManagedObjectTypeProtocol {

    static var entityName: String {
        return "Match"
    }

    func update(withData data: AnyObject, context: NSManagedObjectContext) {
        if let id = data[JSONKeys.Identifier] as? [String : AnyObject], let mId = id[JSONKeys.Matches.matchId] as? String {
            identifier = mId
            gameMode = id[JSONKeys.GameMode] as? Int as NSNumber?
        }
        if let links = data[JSONKeys.Matches.links] as? [String : AnyObject], let details = links[JSONKeys.Matches.matchDetails] as? [String : AnyObject], let path = details[JSONKeys.Matches.matchPath] as? String {
            matchPath = Match.fixedPath(path)
        } else {
            if let identifier = identifier, let gameModeInt = self.gameMode as? Int, let gameMode = GameMode.gameMode(forInt: gameModeInt) {
                matchPath = "\(gameMode.rawValue)/matches/\(identifier)"
            }
        }

        matchDuration = data[JSONKeys.Matches.matchDuration] as? String
        mapId = data[JSONKeys.Matches.mapId] as? String
        if let mvd = data[JSONKeys.MapVariant] as? [String : AnyObject] {
            mapVariantId = mvd[JSONKeys.ResourceId] as? String
            mapVariantOwnerType = mvd[JSONKeys.OwnerType] as? Int as NSNumber?
        }
        if let gbvd = data[JSONKeys.GameVariant] as? [String : AnyObject] {
            gameVariantId = gbvd[JSONKeys.ResourceId] as? String
            gameVariantOwnerType = gbvd[JSONKeys.OwnerType] as? Int as NSNumber?
        }
        if let cdd = data[JSONKeys.Matches.completionDate] as? [String : AnyObject], let dateString = cdd[JSONKeys.ISODate] as? String {
            completionDate = Date.dateFromISOString(dateString)
        }

        isTeamGame = data[JSONKeys.Matches.isTeamGame] as? Bool as NSNumber?
        seasonId = data[JSONKeys.SeasonId] as? String
        playlistId = data[JSONKeys.Matches.playlistId] as? String
        gameBaseVariantId = data[JSONKeys.Matches.gameBaseVariantId] as? String

        if let players = data[JSONKeys.Matches.players] as? [AnyObject], let playerOutcome = players[0][JSONKeys.Matches.result] as? Int {
            outcome = playerOutcome as NSNumber?
        }

        if let t = teams, t.isEmpty {
            if let dataTeams = data[JSONKeys.Matches.teams] as? [AnyObject] {
                let newTeams = Team.objects(forData: dataTeams, context: context)
                teams = NSSet(array: newTeams)
            }
        }
    }
}
