//
//  SetupSpartanOperation.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class SetupSpartanOperation: Operation {

    let gamertag: String

    init(gamertag: String) {
        self.gamertag = gamertag

        super.init()
    }

    override func execute() {
        let spartanImageUrl = ProfileService.spartanImageUrl(forGamertag: gamertag)
        let emblemUrl = ProfileService.emblemUrl(forGamertag: gamertag)

        let data = [
            JSONKeys.Gamertag : gamertag,
            APIConstants.emblem : emblemUrl.absoluteString,
            APIConstants.spartan : spartanImageUrl.absoluteString
        ]

        parseSpartan(data as [String : AnyObject])
    }

    fileprivate func parseSpartan(_ data: [String : AnyObject]) {
        guard let controller = Container.resolve(PersistenceController.self) else { return }
        let context = controller.createChildContext() 

        context.perform {
            Spartan.parse(data, context: context)

            controller.save(context: context)
            controller.save()

            self.finish()
        }
    }
}
