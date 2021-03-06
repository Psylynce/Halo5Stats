//
//  ServiceRecord.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation
import CoreData


class ServiceRecord: NSManagedObject {

    func weaponStats(forIdentifier identifier: String) -> WeaponStats? {
        guard let ws = weaponStats?.allObjects as? [WeaponStats], ws.count != 0 else { return nil }

        for weapon in ws {
            if weapon.identifier == identifier {
                return weapon
            }
        }

        return nil
    }

    func medal(forIdentifier identifier: String) -> MedalAward? {
        guard let medals = medalAwards?.allObjects as? [MedalAward], medals.count != 0 else { return nil }

        for medal in medals {
            if medal.medalIdentifier == identifier {
                return medal
            }
        }

        return nil
    }

    static func parse(_ type: APIConstants.GameMode, data: [String : AnyObject], context: NSManagedObjectContext) {
        guard let players = data[JSONKeys.ServiceRecord.players] as? [AnyObject] else {
            print("No players found for service record")
            return
        }

        for player in players {
            guard let resultCode = player[JSONKeys.ServiceRecord.resultCode] as? Int, resultCode == 0 else { continue }
            guard let gamertag = player[JSONKeys.ServiceRecord.gamertag] as? String else { continue }

            let predicate = NSPredicate.predicate(withGamertag: gamertag)
            guard let spartan = Spartan.findOrFetch(inContext: context, matchingPredicate: predicate) else {
                print("No Spartan for \(gamertag) in ServiceRecord")
                continue
            }

            guard let serviceRecord = player[JSONKeys.ServiceRecord.serviceRecord] as? [String : AnyObject] else {
                print("No service record for \(gamertag)")
                continue
            }

            let capitalizedType = type.rawValue.capitalized
            let statType = type == .warzone ? "\(capitalizedType)Stat" : "\(capitalizedType)Stats"
            guard let stats = serviceRecord[statType] as? [String : AnyObject] else {
                print("No stats for \(type)")
                continue
            }

            if let record = spartan.serviceRecord(forType: type) {
                record.update(withData: stats as AnyObject, context: context)
                record.spartanRank = serviceRecord[JSONKeys.ServiceRecord.spartanRank] as? Int as NSNumber?
            } else {
                let newRecord: ServiceRecord = context.insertObject()
                newRecord.type = type.rawValue
                newRecord.gamertag = spartan.gamertag?.lowercased()
                newRecord.update(withData: stats as AnyObject, context: context)
                newRecord.spartan = spartan
                newRecord.spartanRank = serviceRecord[JSONKeys.ServiceRecord.spartanRank] as? Int as NSNumber?
            }
        }
    }

}

extension ServiceRecord: ManagedObjectTypeProtocol {

    static var entityName: String {
        return "ServiceRecord"
    }

    func update(withData data: AnyObject, context: NSManagedObjectContext) {
        if let stats = baseStats {
            stats.update(withData: data, context: context)
        } else {
            let newStats: BaseStats = context.insertObject()
            newStats.update(withData: data, context: context)
            baseStats = newStats
        }

        if let data = data[JSONKeys.WeaponWithMostKills] as? [String : AnyObject] {
            if let weapon = mostUsedWeapon {
                weapon.update(withData: data as AnyObject, context: context)
            } else {
                let newMuw: WeaponStats = context.insertObject()
                newMuw.update(withData: data as AnyObject, context: context)
                mostUsedWeapon = newMuw
            }
        }

        if let dataWeapons = data[JSONKeys.WeaponStats.weaponStats] as? [AnyObject] {
            for weapon in dataWeapons {
                guard let weaponId = weapon[JSONKeys.WeaponStats.weaponId] as? [String : AnyObject] else { continue }

                if let identifier = weaponId[JSONKeys.WeaponStats.identifier] as? UInt {
                    let stringID = "\(identifier)"
                    if let coreWeapon = self.weaponStats(forIdentifier: stringID) {
                        coreWeapon.update(withData: weapon, context: context)
                    } else {
                        let newWeapon: WeaponStats = context.insertObject()
                        newWeapon.update(withData: weapon, context: context)
                        newWeapon.serviceRecord = self
                    }
                }
            }
        }

        if let medals = data[JSONKeys.MedalAward.medals] as? [AnyObject] {
            for medal in medals {
                guard let id = medal[JSONKeys.MedalAward.medalId] as? UInt else { continue }

                let identifier = "\(id)"
                if let medalAward = self.medal(forIdentifier: identifier) {
                    medalAward.update(withData: medal, context: context)
                } else {
                    let newMedal: MedalAward = context.insertObject()
                    newMedal.update(withData: medal, context: context)
                    newMedal.serviceRecord = self
                }
            }
        }

        if let type = self.type, type == APIConstants.GameMode.arena.rawValue, let highestCSR = data[JSONKeys.AttainedCSR.highestCsrAttained] as? [String : AnyObject] {
            if let hCSR = highestCSRAttained {
                hCSR.update(withData: highestCSR as AnyObject, context: context)
            } else {
                let newHighCSR: AttainedCSR = context.insertObject()
                newHighCSR.update(withData: highestCSR as AnyObject, context: context)
                highestCSRAttained = newHighCSR
            }
        }

        totalGamesCompleted = data[JSONKeys.ServiceRecord.totalGamesCompleted] as? Int as NSNumber?
        totalGamesWon = data[JSONKeys.ServiceRecord.totalGamesWon] as? Int as NSNumber?
        totalGamesLost = data[JSONKeys.ServiceRecord.totalGamesLost] as? Int as NSNumber?
        totalGamesTied = data[JSONKeys.ServiceRecord.totalGamesTied] as? Int as NSNumber?
    }
}
