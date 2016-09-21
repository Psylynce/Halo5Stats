//
//  CarnageReport.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation
import CoreData


class CarnageReport: NSManagedObject {

    static func parse(data: [String : AnyObject], matchId: String, context: NSManagedObjectContext) {
        let predicate = NSPredicate.predicate(withIdentifier: matchId)
        guard let match = Match.findOrFetch(inContext: context, matchingPredicate: predicate) else {
            print("No match found for \(matchId)")
            return
        }
        guard let playerStats = data[JSONKeys.CarnageReport.playerStats] as? [AnyObject] else {
            print("No player stats :(")
            return
        }

        if let carnageReports = match.carnageReports where carnageReports.isEmpty || match.carnageReports == nil {
            var newReports: [CarnageReport] = []

            for player in playerStats {
                let report: CarnageReport = context.insertObject()
                report.update(withData: player, context: context)
                newReports.append(report)
            }

            match.carnageReports = NSSet(array: newReports)
        }
    }

}

extension CarnageReport: ManagedObjectTypeProtocol {

    static var entityName: String {
        return "CarnageReport"
    }

    func update(withData data: AnyObject, context: NSManagedObjectContext) {
        if let playerDict = data[JSONKeys.CarnageReport.player] as? [String : AnyObject] {
            gamertag = playerDict[JSONKeys.Gamertag] as? String
        }
        didNotFinish = data[JSONKeys.CarnageReport.didNotFinish] as? Bool
        rank = data[JSONKeys.CarnageReport.rank] as? Int
        teamId = data[JSONKeys.CarnageReport.teamId] as? Int
        averageLifeTime = data[JSONKeys.CarnageReport.averageLifeTime] as? String
        totalDuration = data[JSONKeys.CarnageReport.totalDuration] as? String

        if baseStats == nil {
            let stats: BaseStats = context.insertObject()
            stats.update(withData: data, context: context)
            baseStats = stats
        }

        if mostUsedWeapon == nil {
            if let mostUsed = data[JSONKeys.WeaponStats.weaponWithMostKills] as? [String : AnyObject] {
                let muw: WeaponStats = context.insertObject()
                muw.update(withData: mostUsed, context: context)
                mostUsedWeapon = muw
            }
        }

        if let weapons = weaponStats where weapons.isEmpty {
            if let wStats = data[JSONKeys.WeaponStats.weaponStats] as? [AnyObject] {
                let newWeaponStats = WeaponStats.objects(forData: wStats, context: context)
                weaponStats = NSSet(array: newWeaponStats)
            }
        }

        if let m = medals where m.isEmpty {
            if let dataMedals = data[JSONKeys.MedalAward.medals] as? [AnyObject] where !dataMedals.isEmpty {
                let newMedals = MedalAward.objects(forData: dataMedals, context: context)
                medals = NSSet(array: newMedals)
            }
        }

        if let kills = aiKills where kills.isEmpty {
            if let aik = data[JSONKeys.EnemyKill.aiEnemies] as? [AnyObject] where !aik.isEmpty {
                let newAIKs = EnemyKill.objects(forData: aik, context: context)
                aiKills = NSSet(array: newAIKs)
            }
        }

        if let kills = vehicleKills where kills.isEmpty {
            if let vk = data[JSONKeys.EnemyKill.vehicles] as? [AnyObject] where !vk.isEmpty {
                let newVehicles = EnemyKill.objects(forData: vk, context: context)
                aiKills = NSSet(array: newVehicles)
            }
        }

        if let ko = killedOpponents where ko.isEmpty {
            if let opponents = data[JSONKeys.OpponentDetail.killed] as? [AnyObject] where !opponents.isEmpty {
                let newKO = OpponentDetail.objects(forData: opponents, context: context)
                killedOpponents = NSSet(array: newKO)
            }
        }

        if let kbo = killedByOpponents where kbo.isEmpty {
            if let opponents = data[JSONKeys.OpponentDetail.killedBy] as? [AnyObject] where !opponents.isEmpty {
                let newKBO = OpponentDetail.objects(forData: opponents, context: context)
                killedByOpponents = NSSet(array: newKBO)
            }
        }
    }
}
