
//  ServiceRecordModel.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

struct ServiceRecordModel {

    var totalGamesCompleted: Int
    var totalGamesWon: Int
    var totalGamesLost: Int
    var totalGamesTied: Int
    var spartanRank: Int?
    var stats: StatsModel
    var mostUsedWeapon: WeaponModel?
    var weapons: [WeaponModel]
    var medals: [MedalModel]
    var topMedals: [MedalModel]
    var highestAttainedCSR: CSRModel?

    static func convert(serviceRecord record: ServiceRecord) -> ServiceRecordModel? {
        guard let baseStats = record.baseStats, let stats = StatsModel.convert(baseStats) else { return nil }
        let mostUsedWeapon = ServiceRecordModel.mostUsedWeapon(record)
        let weapons = ServiceRecordModel.weapons(record)
        let medals = ServiceRecordModel.medals(record)
        let topMedals = ServiceRecordModel.updateTopMedals(medals)

        let gamesCompleted = record.totalGamesCompleted?.intValue ?? 0
        let gamesWon = record.totalGamesWon?.intValue ?? 0
        let gamesLost = record.totalGamesLost?.intValue ?? 0
        let gamesTied = record.totalGamesTied?.intValue ?? 0
        let spartanRank = record.spartanRank?.intValue
        let highestAttainedCSR = ServiceRecordModel.updateHighestCSR(record)

        let model = ServiceRecordModel(totalGamesCompleted: gamesCompleted, totalGamesWon: gamesWon, totalGamesLost: gamesLost, totalGamesTied: gamesTied, spartanRank: spartanRank, stats: stats, mostUsedWeapon: mostUsedWeapon, weapons: weapons, medals: medals, topMedals: topMedals, highestAttainedCSR: highestAttainedCSR)

        return model
    }

    func percentageDetails(_ gameMode: GameMode) -> [PercentageDetail] {
        return [(value: totalGamesWon, color: gameMode.color), (value: totalGamesLost, color: .bismark), (value: totalGamesTied, color: .springGreen)]
    }

    // MARK: - Private Methods

    fileprivate static func mostUsedWeapon(_ record: ServiceRecord) -> WeaponModel? {
        guard let weapon = record.mostUsedWeapon else { return nil }
        guard let model = WeaponModel.convert(weapon) else { return nil }

        return model
    }

    fileprivate static func weapons(_ record: ServiceRecord) -> [WeaponModel] {
        guard let weapons = record.weaponStats?.allObjects as? [WeaponStats] else { return [] }
        let newWeapons = weapons.flatMap { WeaponModel.convert($0) }

        return newWeapons
    }

    fileprivate static func medals(_ record: ServiceRecord) -> [MedalModel] {
        guard let medals = record.medalAwards?.allObjects as? [MedalAward] else { return [] }
        let newMedals = medals.flatMap { MedalModel.convert($0) }

        return newMedals
    }

    fileprivate static func updateTopMedals(_ medals: [MedalModel]) -> [MedalModel] {
        let sortedDifficulty = medals.sorted { $0.difficulty > $1.difficulty }
        let sortedCount = sortedDifficulty.sorted { $0.count > $1.count }

        var n = 0

        if sortedCount.count > 5 {
            n = 5
        } else if sortedCount.count < 5 && sortedCount.count > 0 {
            n = sortedCount.count - 1
        } else {
            n = 0
        }

        let finalArray = Array(sortedCount.prefix(n))

        return finalArray
    }

    fileprivate static func updateHighestCSR(_ record: ServiceRecord) -> CSRModel? {
        guard let csr = record.highestCSRAttained else { return nil }
        guard let model = CSRModel.convert(csr) else { return nil }

        return model
    }
}
