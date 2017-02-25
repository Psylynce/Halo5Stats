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
        case save
        case remove
    }

    func manageSpartan(_ gamertag: String) {
        var favorites = self.favorites()
        let isFavorite = self.isFavorite(gamertag)
        let action: Action = isFavorite ? .remove : .save

        switch action {
        case .save:
            if favorites.contains(gamertag) {
                return
            }

            favorites.append(gamertag)
        case .remove:
            if let index = favorites.index(of: gamertag) {
                favorites.remove(at: index)
            }
        }

        UserDefaults.standard.set(favorites, forKey: K.favoritesKey)
        UserDefaults.standard.synchronize()
    }

    func deleteSpartan(_ gamertag: String) {
        guard isFavorite(gamertag) else { return }

        var favorites = self.favorites()
        guard let index = favorites.index(of: gamertag) else { return }

        favorites.remove(at: index)

        UserDefaults.standard.set(favorites, forKey: K.favoritesKey)
        UserDefaults.standard.synchronize()
    }

    func isFavorite(_ gamertag: String) -> Bool {
        let favorites = self.favorites()

        return favorites.contains(gamertag)
    }

    func favorites() -> [String] {
        guard let favorites = UserDefaults.standard.object(forKey: K.favoritesKey) as? [String] else { return [] }

        return favorites
    }
}
