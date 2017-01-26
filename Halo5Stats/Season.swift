//
//  Season.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation
import CoreData


class Season: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

}

extension Season: ManagedObjectTypeProtocol {

    static var entityName: String {
        return "Season"
    }

    static func parse(_ data: [String : AnyObject], context: NSManagedObjectContext) {
        guard let seasons = data[JSONKeys.Season.seasons] as? [AnyObject] else { return }

        for season in seasons {
            guard let identifier = season[JSONKeys.identifier] as? String else {
                print("No Season Found")
                continue
            }

            let predicate = NSPredicate.predicate(withIdentifier: identifier)

            Season.findOrCreate(inContext: context, matchingPredicate: predicate) {
                $0.name = season[JSONKeys.name] as? String
                $0.startDate = season[JSONKeys.Season.startDate] as? String
                $0.endDate = season[JSONKeys.Season.endDate] as? String
                $0.isActive = season[JSONKeys.Season.isActive] as? Bool as NSNumber?
                $0.iconUrl = season[JSONKeys.iconUrl] as? String
                $0.identifier = identifier


                if let playlistArray = season[JSONKeys.Playlist.playlists] as? [AnyObject] {
                    var playlists: [Playlist] = []
                    
                    for playlist in playlistArray {
                        guard let playlistIdentifier = playlist[JSONKeys.identifier] as? String else {
                            print("No Playlist found for Season")
                            continue
                        }

                        let playlistPredicate = NSPredicate.predicate(withIdentifier: playlistIdentifier)
                        Playlist.findOrCreate(inContext: context, matchingPredicate: playlistPredicate) {
                            $0.name = playlist[JSONKeys.name] as? String
                            $0.overview = playlist[JSONKeys.overview] as? String
                            $0.gameMode = playlist[JSONKeys.Playlist.gameMode] as? String
                            $0.imageUrl = playlist[JSONKeys.imageUrl] as? String
                            $0.isActive = playlist[JSONKeys.Playlist.isActive] as? Bool as NSNumber?
                            $0.isRanked = playlist[JSONKeys.Playlist.isRanked] as? Bool as NSNumber?
                            $0.identifier = playlistIdentifier

                            playlists += [$0]
                        }
                    }
                    
                    $0.playlists = NSSet(array: playlists)
                }
            }
        }
    }
}
