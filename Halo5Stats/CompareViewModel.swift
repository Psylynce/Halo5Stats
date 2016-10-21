//
//  CompareViewModel.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

enum CompareSection {
    case Arena
    case Warzone
    case Custom

    var gameMode: GameMode {
        switch self {
        case .Arena:
            return .Arena
        case .Warzone:
            return .Warzone
        case .Custom:
            return .Custom
        }
    }

    var title: String {
        return gameMode.title
    }
}

class CompareViewModel {

    var spartans: Dynamic<[SpartanModel]> = Dynamic([])
    var sections: [CompareSection] = [.Arena, .Warzone, .Custom]
    var arenaStats: Dynamic<[StatCompareItem]> = Dynamic([])
    var warzoneStats: Dynamic<[StatCompareItem]> = Dynamic([])
    var customStats: Dynamic<[StatCompareItem]> = Dynamic([])

    func numberOfRows(forSection section: CompareSection) -> Int {
        switch section {
        case .Arena:
            return arenaStats.value.count
        case .Warzone:
            return warzoneStats.value.count
        case .Custom:
            return customStats.value.count
        }
    }

    func compareItem(indexPath: NSIndexPath) -> StatCompareItem {
        let section = sections[indexPath.section]

        switch section {
        case .Arena:
            return arenaStats.value[indexPath.row]
        case .Warzone:
            return warzoneStats.value[indexPath.row]
        case .Custom:
            return customStats.value[indexPath.row]
        }
    }

    func setupStats(forSection section: CompareSection, statsModel: ComparableStatModel) {
        let items = statsModel.comparisonItems()

        switch section {
        case .Arena:
            arenaStats.value = items
        case .Warzone:
            warzoneStats.value = items
        case .Custom:
            customStats.value = items
        }
    }

    func setupComparableStats() {
        guard spartans.value.count == 2 else { return }
        let playerOne = spartans.value[0]
        let playerTwo = spartans.value[1]

        for section in sections {
            guard let playerOneServiceRecord = playerOne.spartan.serviceRecord(forType: section.gameMode.rawValue) else { return }
            guard let playerTwoServiceRecord = playerTwo.spartan.serviceRecord(forType: section.gameMode.rawValue) else { return }
            guard let playerOneModel = ServiceRecordModel.convert(serviceRecord: playerOneServiceRecord) else { return }
            guard let playerTwoModel = ServiceRecordModel.convert(serviceRecord: playerTwoServiceRecord) else { return }
            let compareModel = ComparableStatModel(playerOne: playerOneModel, playerTwo: playerTwoModel)
            setupStats(forSection: section, statsModel: compareModel)
        }
    }
}
