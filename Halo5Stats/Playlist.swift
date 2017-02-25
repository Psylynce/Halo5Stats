//
//  Playlist.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation
import CoreData


class Playlist: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

}

extension Playlist: ManagedObjectTypeProtocol {

    static var entityName: String {
        return "Playlist"
    }

    static func parse(_ data: [String : AnyObject], context: NSManagedObjectContext) {
        guard let playlists = data[JSONKeys.Playlist.playlists] as? [AnyObject] else { return }

        for playlist in playlists {
            guard let identifier = playlist[JSONKeys.identifier] as? String else {
                print("No Playlist Found")
                continue
            }

            let predicate = NSPredicate.predicate(withIdentifier: identifier)

            Playlist.findOrCreate(inContext: context, matchingPredicate: predicate) {
                $0.name = playlist[JSONKeys.name] as? String
                $0.overview = playlist[JSONKeys.overview] as? String
                $0.gameMode = playlist[JSONKeys.Playlist.gameMode] as? String
                $0.imageUrl = playlist[JSONKeys.imageUrl] as? String
                $0.isActive = playlist[JSONKeys.Playlist.isActive] as? Bool as NSNumber?
                $0.isRanked = playlist[JSONKeys.Playlist.isRanked] as? Bool as NSNumber?
                $0.identifier = identifier
            }
        }
    }
}
