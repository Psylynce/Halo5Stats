//
//  MedalAward.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit
import CoreData


class MedalAward: NSManagedObject {

    static func medal(forIdentifier id: Int) -> MedalAward? {
        let context = UIApplication.appController().managedObjectContext()
        let predicate = NSPredicate.predicate(withNumberIdentifier: id)
        guard let medal = MedalAward.findOrFetch(inContext: context, matchingPredicate: predicate) else { return nil }

        return medal
    }
}

extension MedalAward: ManagedObjectTypeProtocol {

    static var entityName: String {
        return "MedalAward"
    }

    func update(withData data: AnyObject, context: NSManagedObjectContext) {
        let medalId = data[JSONKeys.MedalAward.medalId] as? UInt
        if let medalId = medalId {
            medalIdentifier = "\(medalId)"
        }
        count = data[JSONKeys.MedalAward.count] as? Int
    }
}
