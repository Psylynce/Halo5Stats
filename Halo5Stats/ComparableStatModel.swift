//
//  ComparableStatModel.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation

struct ComparableStatModel {

    var playerOne: ServiceRecordModel
    var playerTwo: ServiceRecordModel

    func comparisonItems() -> [StatCompareItem] {
        let gamesWon = StatCompareItem(name: "Games Won", playerOneValue: Double(playerOne.totalGamesWon), playerTwoValue: Double(playerTwo.totalGamesWon))
        let gamesLost = StatCompareItem(name: "Games Lost", playerOneValue: Double(playerOne.totalGamesLost), playerTwoValue: Double(playerTwo.totalGamesLost))
        let gamesTied = StatCompareItem(name: "Games Tied", playerOneValue: Double(playerOne.totalGamesTied), playerTwoValue: Double(playerTwo.totalGamesTied))
        let kda = StatCompareItem(name: "KDA", playerOneValue: playerOne.stats.kda(playerOne.totalGamesCompleted), playerTwoValue: playerTwo.stats.kda(playerTwo.totalGamesCompleted))
        let baseStats = StatsModel.comparableStats(playerOne.stats, playerTwo: playerTwo.stats)

        var items = [gamesWon, gamesLost, gamesTied, kda]

        items += baseStats

        return items
    }
}

struct StatCompareItem {
    var name: String
    var playerOneValue: Double
    var playerTwoValue: Double
}

