//
//  CompareViewModel.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

enum CompareSection {
    case arena
    case warzone
    case custom

    var gameMode: GameMode {
        switch self {
        case .arena:
            return .arena
        case .warzone:
            return .warzone
        case .custom:
            return .custom
        }
    }

    var title: String {
        return gameMode.title
    }
}

class CompareViewModel {

    var spartans: Dynamic<[SpartanModel]> = Dynamic([])
    var sections: [CompareSection] = [.arena, .warzone, .custom]
    var arenaStats: Dynamic<[StatCompareItem]> = Dynamic([])
    var warzoneStats: Dynamic<[StatCompareItem]> = Dynamic([])
    var customStats: Dynamic<[StatCompareItem]> = Dynamic([])

    func numberOfRows(forSection section: CompareSection) -> Int {
        switch section {
        case .arena:
            return arenaStats.value.count
        case .warzone:
            return warzoneStats.value.count
        case .custom:
            return customStats.value.count
        }
    }

    func compareItem(_ indexPath: IndexPath) -> StatCompareItem {
        let section = sections[indexPath.section]

        switch section {
        case .arena:
            return arenaStats.value[indexPath.row]
        case .warzone:
            return warzoneStats.value[indexPath.row]
        case .custom:
            return customStats.value[indexPath.row]
        }
    }

    func setupStats(forSection section: CompareSection, statsModel: ComparableStatModel) {
        let items = statsModel.comparisonItems()

        switch section {
        case .arena:
            arenaStats.value = items
        case .warzone:
            warzoneStats.value = items
        case .custom:
            customStats.value = items
        }
    }

    func setupComparableStats() {
        guard spartans.value.count == 2 else { return }
        let playerOne = spartans.value[0]
        let playerTwo = spartans.value[1]

        for section in sections {
            guard let playerOneServiceRecord = playerOne.spartan.serviceRecord(forType: section.gameMode) else { return }
            guard let playerTwoServiceRecord = playerTwo.spartan.serviceRecord(forType: section.gameMode) else { return }
            guard let playerOneModel = ServiceRecordModel.convert(serviceRecord: playerOneServiceRecord) else { return }
            guard let playerTwoModel = ServiceRecordModel.convert(serviceRecord: playerTwoServiceRecord) else { return }
            let compareModel = ComparableStatModel(playerOne: playerOneModel, playerTwo: playerTwoModel)
            setupStats(forSection: section, statsModel: compareModel)
        }
    }
}
