//
//  MedalDetailViewModel.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation

class MedalDetailViewModel {

    let medal: MedalModel
    let imageManager: MedalImageManager

    init(medal: MedalModel, imageManager: MedalImageManager) {
        self.medal = medal
        self.imageManager = imageManager
    }
}
