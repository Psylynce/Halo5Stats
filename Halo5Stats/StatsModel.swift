//
//  StatsModel.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation

struct StatsModel {
    var kills: Int
    var deaths: Int
    var assists: Int
    var headshots: Int
    var shotsFired: Int
    var shotsLanded: Int
    var weaponDamage: Double
    var meleeKills: Int
    var meleeDamage: Double
    var assassinations: Int
    var groundPoundKills: Int
    var groundPoundDamage: Double
    var shoulderBashKills: Int
    var shoulderBashDamage: Double
    var grenadeKills: Int
    var grenadeDamage: Double
    var powerWeaponKills: Int
    var powerWeaponDamage: Double
    var powerWeaponGrabs: Int
    var powerWeaponPossessionTime: String

    static func convert(stats: BaseStats) -> StatsModel? {
        guard let kills = stats.totalKills?.integerValue else { return nil }
        guard let deaths = stats.totalDeaths?.integerValue else { return nil }
        guard let assists = stats.totalAssists?.integerValue else { return nil }
        guard let headshots = stats.totalHeadshots?.integerValue else { return nil }
        guard let shotsFired = stats.totalShotsFired?.integerValue else { return nil }
        guard let shotsLanded = stats.totalShotsLanded?.integerValue else { return nil }
        guard let weaponDamage = stats.totalWeaponDamage?.doubleValue else { return nil }
        guard let melees = stats.totalMeleeKills?.integerValue else { return nil }
        guard let meleeDamage = stats.totalMeleeDamage?.doubleValue else { return nil }
        guard let assassinations = stats.totalAssassinations?.integerValue else { return nil }
        guard let groundPoundKills = stats.totalGroundPoundKills?.integerValue else { return nil }
        guard let groundPoundDamage = stats.totalGroundPoundDamage?.doubleValue else { return nil }
        guard let shoulderKills = stats.totalShoulderBashKills?.integerValue else { return nil }
        guard let shoulderDamage = stats.totalShoulderBashDamage?.doubleValue else { return nil }
        guard let grenadeKills = stats.totalGrenadeKills?.integerValue else { return nil }
        guard let grenadeDamage = stats.totalGrenadeDamage?.doubleValue else { return nil }
        guard let powerWeaponKills = stats.totalPowerWeaponKills?.integerValue else { return nil }
        guard let powerWeaponDamage = stats.totalPowerWeaponDamage?.doubleValue else { return nil }
        guard let powerWeaponGrabs = stats.totalPowerWeaponGrabs?.integerValue else { return nil }
        guard let powerWeaponPossessionTime = stats.totalPowerWeaponPossessionTime, possessionTime = DurationFormatter.readableDuration(powerWeaponPossessionTime) else { return nil }

        let model = StatsModel(kills: kills, deaths: deaths, assists: assists, headshots: headshots, shotsFired: shotsFired, shotsLanded: shotsLanded, weaponDamage: weaponDamage.roundedToTwo(), meleeKills: melees, meleeDamage: meleeDamage.roundedToTwo(), assassinations: assassinations, groundPoundKills: groundPoundKills, groundPoundDamage: groundPoundDamage.roundedToTwo(), shoulderBashKills: shoulderKills, shoulderBashDamage: shoulderDamage.roundedToTwo(), grenadeKills: grenadeKills, grenadeDamage: grenadeDamage.roundedToTwo(), powerWeaponKills: powerWeaponKills, powerWeaponDamage: powerWeaponDamage.roundedToTwo(), powerWeaponGrabs: powerWeaponGrabs, powerWeaponPossessionTime: possessionTime)

        return model
    }

    static func comparableStats(playerOne: StatsModel, playerTwo: StatsModel) -> [StatCompareItem] {
        let kd = StatCompareItem(name: "KD", playerOneValue: playerOne.killDeathRatio(), playerTwoValue: playerTwo.killDeathRatio())
        let killsItem = StatCompareItem(name: "Kills", playerOneValue: Double(playerOne.kills), playerTwoValue: Double(playerTwo.kills))
        let deathsItem = StatCompareItem(name: "Deaths", playerOneValue: Double(playerOne.deaths), playerTwoValue: Double(playerTwo.deaths))
        let assistsItem = StatCompareItem(name: "Assists", playerOneValue: Double(playerOne.assists), playerTwoValue: Double(playerTwo.assists))
        let headshotsItem = StatCompareItem(name: "Headshots", playerOneValue: Double(playerOne.headshots), playerTwoValue: Double(playerTwo.headshots))
        let shotsFiredItem = StatCompareItem(name: "Shots Fired", playerOneValue: Double(playerOne.shotsFired), playerTwoValue: Double(playerTwo.shotsFired))
        let shotsLandedItem = StatCompareItem(name: "Shots Landed", playerOneValue: Double(playerOne.shotsLanded), playerTwoValue: Double(playerTwo.shotsLanded))
        let weaponDamageItem = StatCompareItem(name: "Weapon Damage", playerOneValue: playerOne.weaponDamage, playerTwoValue: playerTwo.weaponDamage)
        let meleeKillsItem = StatCompareItem(name: "Melee Kills", playerOneValue: Double(playerOne.meleeKills), playerTwoValue: Double(playerTwo.meleeKills))
        let meleeDamageItem = StatCompareItem(name: "Melee Damage", playerOneValue: playerOne.meleeDamage, playerTwoValue: playerTwo.meleeDamage)
        let assassinationsItem = StatCompareItem(name: "Assassinations", playerOneValue: Double(playerOne.assassinations), playerTwoValue: Double(playerTwo.assassinations))
        let groundPoundKillsItem = StatCompareItem(name: "Ground Pound Kills", playerOneValue: Double(playerOne.groundPoundKills), playerTwoValue: Double(playerTwo.groundPoundKills))
        let groundPoundDamageItem = StatCompareItem(name: "Ground Pound Damage", playerOneValue: playerOne.groundPoundDamage, playerTwoValue: playerTwo.groundPoundDamage)
        let shoulderBashKillsItem = StatCompareItem(name: "Shoulder Bash Kills", playerOneValue: Double(playerOne.shoulderBashKills), playerTwoValue: Double(playerTwo.shoulderBashKills))
        let shoulderBashDamageItem = StatCompareItem(name: "Shoulder Bash Damage", playerOneValue: playerOne.shoulderBashDamage, playerTwoValue: playerTwo.shoulderBashDamage)
        let grenadeKillsItem = StatCompareItem(name: "Grenade Kills", playerOneValue: Double(playerOne.grenadeKills), playerTwoValue: Double(playerTwo.grenadeKills))
        let grenadeDamageItem = StatCompareItem(name: "Grenade Damage", playerOneValue: playerOne.grenadeDamage, playerTwoValue: playerTwo.grenadeDamage)
        let powerWeaponKillsItem = StatCompareItem(name: "Power Weapon Kills", playerOneValue: Double(playerOne.powerWeaponKills), playerTwoValue: Double(playerTwo.powerWeaponKills))
        let powerWeaponDamageItem = StatCompareItem(name: "Power Weapon Damage", playerOneValue: playerOne.powerWeaponDamage, playerTwoValue: playerTwo.powerWeaponDamage)
        let powerWeaponGrabsItem = StatCompareItem(name: "Power Weapon Grabs", playerOneValue: Double(playerOne.powerWeaponGrabs), playerTwoValue: Double(playerTwo.powerWeaponGrabs))

        let stats: [StatCompareItem] = [kd, killsItem, deathsItem, assistsItem, headshotsItem, shotsFiredItem, shotsLandedItem, weaponDamageItem, meleeKillsItem, meleeDamageItem, assassinationsItem, groundPoundKillsItem, groundPoundDamageItem, shoulderBashKillsItem, shoulderBashDamageItem, grenadeKillsItem, grenadeDamageItem, powerWeaponKillsItem, powerWeaponDamageItem, powerWeaponGrabsItem]

        return stats
    }

    func killDeathRatio() -> Double {
        let kills = Double(self.kills)
        let deaths = Double(self.deaths)

        let kd = kills / deaths

        return kd.roundedToTwo()
    }

    func kda(games: Int) -> Double {
        let kills = Double(self.kills)
        let deaths = Double(self.deaths)
        let assists = Double(self.assists)
        let totalGames = Double(games)

        let kda = ((kills + (assists / 3.0)) - deaths) / totalGames

        return kda.roundedToTwo()
    }

    func statDisplayItems() -> [DisplayItem] {
        let killsItem = StatDisplayItem(statTitle: "Kills", statCount: "\(kills)")
        let deathsItem = StatDisplayItem(statTitle: "Deaths", statCount: "\(deaths)")
        let assistsItem = StatDisplayItem(statTitle: "Assists", statCount: "\(assists)")
        let headshotsItem = StatDisplayItem(statTitle: "Headshots", statCount: "\(headshots)")
        let shotsFiredItem = StatDisplayItem(statTitle: "Shots Fired", statCount: "\(shotsFired)")
        let shotsLandedItem = StatDisplayItem(statTitle: "Shots Landed", statCount: "\(shotsLanded)")
        let weaponDamageItem = StatDisplayItem(statTitle: "Weapon Damage", statCount: "\(weaponDamage)")
        let meleeKillsItem = StatDisplayItem(statTitle: "Melee Kills", statCount: "\(meleeKills)")
        let meleeDamageItem = StatDisplayItem(statTitle: "Melee Damage", statCount: "\(meleeDamage)")
        let assassinationsItem = StatDisplayItem(statTitle: "Assassinations", statCount: "\(assassinations)")
        let groundPoundKillsItem = StatDisplayItem(statTitle: "Ground Pound Kills", statCount: "\(groundPoundKills)")
        let groundPoundDamageItem = StatDisplayItem(statTitle: "Ground Pound Damage", statCount: "\(groundPoundDamage)")
        let shoulderBashKillsItem = StatDisplayItem(statTitle: "Shoulder Bash Kills", statCount: "\(shoulderBashKills)")
        let shoulderBashDamageItem = StatDisplayItem(statTitle: "Shoulder Bash Damage", statCount: "\(shoulderBashDamage)")
        let grenadeKillsItem = StatDisplayItem(statTitle: "Grenade Kills", statCount: "\(grenadeKills)")
        let grenadeDamageItem = StatDisplayItem(statTitle: "Grenade Damage", statCount: "\(grenadeDamage)")
        let powerWeaponKillsItem = StatDisplayItem(statTitle: "Power Weapon Kills", statCount: "\(powerWeaponKills)")
        let powerWeaponDamageItem = StatDisplayItem(statTitle: "Power Weapon Damage", statCount: "\(powerWeaponDamage)")
        let powerWeaponGrabsItem = StatDisplayItem(statTitle: "Power Weapon Grabs", statCount: "\(powerWeaponGrabs)")
        let powerWeaponPossessionTimeItem = StatDisplayItem(statTitle: "Power Weapon Possession Time", statCount: powerWeaponPossessionTime)

        let stats: [StatDisplayItem] = [killsItem, deathsItem, assistsItem, headshotsItem, shotsFiredItem, shotsLandedItem, weaponDamageItem, meleeKillsItem, meleeDamageItem, assassinationsItem, groundPoundKillsItem, groundPoundDamageItem, shoulderBashKillsItem, shoulderBashDamageItem, grenadeKillsItem, grenadeDamageItem, powerWeaponKillsItem, powerWeaponDamageItem, powerWeaponGrabsItem, powerWeaponPossessionTimeItem]

        return stats.map { $0 as DisplayItem }
    }
}

struct StatDisplayItem: DisplayItem {
    var statTitle: String
    var statCount: String

    var title: String? {
        return statTitle
    }

    var number: String {
        return statCount
    }

    var url: NSURL? {
        return nil
    }
}
