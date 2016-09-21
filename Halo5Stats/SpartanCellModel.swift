//
//  SpartanCellModel.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation

class SpartanCellModel {

    let spartan: SpartanModel
    var isComparing: Dynamic<Bool> = Dynamic(false)
    var isFavorite: Dynamic<Bool> = Dynamic(false)

    init(spartan: SpartanModel, isComparing: Bool) {
        self.spartan = spartan
        self.isComparing.value = isComparing
        self.isFavorite.value = FavoritesManager.sharedManager.isFavorite(spartan.gamertag)
    }
}
