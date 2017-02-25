//
//  OpponentDetailCellModel.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation

class OpponentDetailCellModel: ScoreCollectionViewDataSource {

    let opponents: [OpponentDetailModel]

    init(opponents: [OpponentDetailModel]) {
        self.opponents = opponents
    }

    var type: ScoreCollectionViewCellType {
        return .playerScore
    }

    var items: [DisplayItem] {
        return OpponentDetailModel.displayItems(opponents)
    }
}
