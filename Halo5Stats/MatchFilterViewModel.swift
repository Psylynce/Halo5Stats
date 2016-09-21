//
//  MatchFilterViewModel.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

protocol MatchFilterDelegate: class {
    func applyFilters(model: MatchFilterViewModel)
}

class MatchFilterViewModel {

    weak var delegate: MatchFilterDelegate?

    var arenaSelected: Dynamic<Bool> = Dynamic(false)
    var warzoneSelected: Dynamic<Bool> = Dynamic(false)
    var customsSelected: Dynamic<Bool> = Dynamic(false)

    func applyFilters() {
        self.delegate?.applyFilters(self)
    }

    func isFiltered() -> Bool {
        return arenaSelected.value || warzoneSelected.value || customsSelected.value
    }
}
