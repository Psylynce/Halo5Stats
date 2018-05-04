//
//  MatchPlayerModel.swift
//  Halo5Stats
//
//  Created by Justin Powell on 4/14/16.
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation

struct MatchPlayerModel {
    var gamertag: String
    var emblemUrl: URL
    var rank: Int
    var teamId: Int
    var didNotFinish: Bool
    var stats: StatsModel
    var teamColor: TeamColor?
    var medals: [MedalModel]
    var mostUsedWeapon: WeaponModel?
    var weapons: [WeaponModel]
    var killedOpponents: [OpponentDetailModel]
    var killedByOpponents: [OpponentDetailModel]

    static func convert(_ report: CarnageReport) -> MatchPlayerModel? {
        guard let gamertag = report.gamertag else { return nil }
        guard let teamId = report.teamId else { return nil }
        guard let rank = report.rank else { return nil }
        guard let didNotFinish = report.didNotFinish else { return nil }
        guard let baseStats = report.baseStats, let stats = StatsModel.convert(baseStats) else { return nil }
        let teamColor = TeamColor.teamColor(forIdentifier: teamId.intValue)
        let mostUsedWeapon = MatchPlayerModel.mostUsedWeapon(report)
        let weapons = MatchPlayerModel.weapons(report).filter { $0.weaponId != mostUsedWeapon?.weaponId }
        let medals = MatchPlayerModel.medals(report)
        let killedOpponents = MatchPlayerModel.opponentDetails(true, report: report)
        let killedByOpponents = MatchPlayerModel.opponentDetails(false, report: report)

        let emblemUrl = ProfileService.emblemUrl(forGamertag: gamertag)

        let model = MatchPlayerModel(gamertag: gamertag, emblemUrl: emblemUrl, rank: rank.intValue, teamId: teamId.intValue, didNotFinish: didNotFinish.boolValue, stats: stats, teamColor: teamColor, medals: medals, mostUsedWeapon: mostUsedWeapon, weapons: weapons, killedOpponents: killedOpponents, killedByOpponents: killedByOpponents)
        return model
    }

    static func displayItems(_ players: [MatchPlayerModel]) -> [DisplayItem] {
        return players.map { $0 as DisplayItem }
    }

    // MARK: - Private

    fileprivate static func mostUsedWeapon(_ report: CarnageReport) -> WeaponModel? {
        guard let weapon = report.mostUsedWeapon else { return nil }
        guard let model = WeaponModel.convert(weapon) else { return nil }

        return model
    }

    fileprivate static func weapons(_ report: CarnageReport) -> [WeaponModel] {
        guard let reportWeapons = report.weaponStats?.allObjects as? [WeaponStats] else { return [] }

        let weapons = reportWeapons.compactMap { WeaponModel.convert($0) }

        return weapons
    }

    fileprivate static func medals(_ report: CarnageReport) -> [MedalModel] {
        guard let medals = report.medals?.allObjects as? [MedalAward] else { return [] }

        var newMedals = medals.compactMap { MedalModel.convert($0) }
        newMedals.sort { $0.count > $1.count }

        return newMedals
    }

    fileprivate static func opponentDetails(_ killed: Bool, report: CarnageReport) -> [OpponentDetailModel] {
        let opponents = killed ? report.killedOpponents : report.killedByOpponents
        guard let os = opponents?.allObjects as? [OpponentDetail] else { return [] }

        var models = os.compactMap { OpponentDetailModel.convert($0) }
        models.sort { $0.killCount > $1.killCount }

        return models
    }
}

extension MatchPlayerModel: DisplayItem {

    var title: String? {
        return gamertag
    }

    var number: String {
        return "\(stats.kills)"
    }

    var url: URL? {
        return emblemUrl
    }
}
