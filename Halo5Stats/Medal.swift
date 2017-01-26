//
//  Medal.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit
import CoreData


class Medal: NSManagedObject {

    static func medal(forIdentifier id: String) -> Medal? {
        let context = UIApplication.appController().managedObjectContext()
        let predicate = NSPredicate.predicate(withIdentifier: id)
        guard let medal = Medal.findOrFetch(inContext: context, matchingPredicate: predicate) else { return nil }
        
        return medal
    }

}

extension Medal: ManagedObjectTypeProtocol {

    static var entityName: String {
        return "Medal"
    }

    static func parse(_ data: [String : AnyObject], context: NSManagedObjectContext) {
        guard let medals = data[JSONKeys.Medal.medals] as? [AnyObject] else { return }

        for medal in medals {
            guard let identifier = medal[JSONKeys.identifier] as? String else { continue }
            let predicate = NSPredicate.predicate(withIdentifier: identifier)

            Medal.findOrCreate(inContext: context, matchingPredicate: predicate) {
                $0.name = medal[JSONKeys.name] as? String
                $0.overview = medal[JSONKeys.overview] as? String
                $0.classification = medal[JSONKeys.Medal.classification] as? String
                $0.difficulty = medal[JSONKeys.Medal.difficulty] as? Int as NSNumber?
                if let sld = medal[JSONKeys.Medal.spriteLocation] as? [String : AnyObject] {
                    let locationX = sld[JSONKeys.Medal.left] as! Int
                    $0.spriteLocationX = NSNumber(value: locationX as Int)
                    let locationY = sld[JSONKeys.Medal.top] as! Int
                    $0.spriteLocationY = NSNumber(value: locationY as Int)
                    let spriteHeight = sld[JSONKeys.Medal.height] as! Int
                    $0.spriteHeight = NSNumber(value: spriteHeight as Int)
                    let spriteWidth = sld[JSONKeys.Medal.width] as! Int
                    $0.spriteWidth = NSNumber(value: spriteWidth as Int)
                    $0.spriteImageUrl = sld[JSONKeys.Medal.spriteSheetUrl] as? String
                }
                $0.identifier = identifier
            }
        }
    }
}
