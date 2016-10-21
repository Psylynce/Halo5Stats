//
//  Spartan.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit
import CoreData


class Spartan: NSManagedObject {

    func match(forIdentifier identifier: String) -> Match? {
        guard let m = matches?.allObjects as? [Match] where m.count != 0 else { return nil }

        for match in m {
            if match.identifier == identifier {
                return match
            }
        }

        return nil
    }

    func serviceRecord(forType type: String) -> ServiceRecord? {
        guard let records = serviceRecords?.allObjects as? [ServiceRecord] where records.count != 0 else { return nil}

        for record in records {
            if record.type == type {
                return record
            }
        }

        return nil
    }

    func setDisplayGamertag(fromMatch match: AnyObject) {
        guard displayGamertag == nil else { return }
        guard let players = match[JSONKeys.Matches.players] as? [AnyObject], player = players[0][JSONKeys.Matches.player] as? [String : AnyObject], gamertag = player[JSONKeys.Gamertag] as? String else { return }
        self.displayGamertag = gamertag
    }

    static func deleteSpartan(gamertag: String, context: NSManagedObjectContext = UIApplication.appController().managedObjectContext(), completion: (success: Bool) -> Void) {
        guard let spartan = Spartan.spartan(gamertag) else {
            completion(success: false)
            return
        }

        context.deleteObject(spartan)
        SpartanManager.sharedManager.deleteSpartan(gamertag)
        FavoritesManager.sharedManager.deleteSpartan(gamertag)
        completion(success: true)
        UIApplication.appController().persistenceController.save()
    }

    static func spartan(gamertag: String) -> Spartan? {
        let context = UIApplication.appController().managedObjectContext()
        let predicate = NSPredicate.predicate(withGamertag: gamertag.lowercaseString)
        guard let spartan = Spartan.findOrFetch(inContext: context, matchingPredicate: predicate) else {
            print("Ooops could not find spartan")
            return nil
        }

        return spartan
    }

}

extension Spartan: ManagedObjectTypeProtocol {

    static var entityName: String {
        return "Spartan"
    }

    static func parse(data: [String : AnyObject], context: NSManagedObjectContext) {
        guard let gamertag = data[JSONKeys.Gamertag] as? String else {
            print("Gamertag was empty")
            return
        }

        let predicate = NSPredicate.predicate(withGamertag: gamertag)
        Spartan.findOrCreate(inContext: context, matchingPredicate: predicate) {
            $0.gamertag = gamertag
            $0.emblemImageUrl = data[APIConstants.emblem] as? String
            $0.spartanImageUrl = data[APIConstants.spartan] as? String
        }
        print("Spartan set up for \(gamertag)")
    }
}
