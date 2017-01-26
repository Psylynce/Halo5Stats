//
//  OpponentDetail.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation
import CoreData


class OpponentDetail: NSManagedObject {

}

extension OpponentDetail: ManagedObjectTypeProtocol {

    static var entityName: String {
        return "OpponentDetail"
    }

    func update(withData data: AnyObject, context: NSManagedObjectContext) {
        gamertag = data[JSONKeys.OpponentDetail.gamertag] as? String
        killCount = data[JSONKeys.OpponentDetail.totalKills] as? Int as NSNumber?

        if let gt = gamertag {
            emblemUrl = ProfileService.emblemUrl(forGamertag: gt).absoluteString
        }
    }
}
