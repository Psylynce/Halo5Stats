//
//  FavoritesManager.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation

class FavoritesManager {

    static let sharedManager = FavoritesManager()

    struct K {
        static let favoritesKey = "favoriteSpartans"
    }

    enum Action {
        case Save
        case Remove
    }

    func manageSpartan(gamertag: String) {
        var favorites = self.favorites()
        let isFavorite = self.isFavorite(gamertag)
        let action: Action = isFavorite ? .Remove : .Save

        switch action {
        case .Save:
            if favorites.contains(gamertag) {
                return
            }

            favorites.append(gamertag)
        case .Remove:
            if let index = favorites.indexOf(gamertag) {
                favorites.removeAtIndex(index)
            }
        }

        NSUserDefaults.standardUserDefaults().setObject(favorites, forKey: K.favoritesKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    func deleteSpartan(gamertag: String) {
        guard isFavorite(gamertag) else { return }

        var favorites = self.favorites()
        guard let index = favorites.indexOf(gamertag) else { return }

        favorites.removeAtIndex(index)

        NSUserDefaults.standardUserDefaults().setObject(favorites, forKey: K.favoritesKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    func isFavorite(gamertag: String) -> Bool {
        let favorites = self.favorites()

        return favorites.contains(gamertag)
    }

    func favorites() -> [String] {
        guard let favorites = NSUserDefaults.standardUserDefaults().objectForKey(K.favoritesKey) as? [String] else { return [] }

        return favorites
    }
}
