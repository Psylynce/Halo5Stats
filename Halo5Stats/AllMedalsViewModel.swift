//
//  AllMedalsViewModel.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation

class AllMedalsViewModel {

    let allMedals: [MedalModel]
    let imageManager = MedalImageManager()

    init(medals: [MedalModel]) {
        allMedals = medals.sorted { $0.name < $1.name }
    }
}
