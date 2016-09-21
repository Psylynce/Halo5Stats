//
//  PlayerCarnageReportViewModel.swift
//  Halo5Stats
//
//  Created by Justin Powell on 4/19/16.
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

enum PlayerCarnageReportSection {
    case KDandKDA
    case MedalsTitle
    case Medals
    case MostUsedWeaponTitle
    case MostUsedWeapon
    case WeaponsTitle
    case Weapons
    case StatsTitle
    case Stats
    case KilledTitle
    case KilledOpponents
    case KilledByTitle
    case KilledByOpponents

    func title() -> String {
        switch self {
        case .MedalsTitle:
            return "Medals Earned"
        case .MostUsedWeaponTitle:
            return "Tool of Destruction"
        case .WeaponsTitle:
            return "Weapons Used"
        case .StatsTitle:
            return "Match Stats"
        case .KilledTitle:
            return "Killed"
        case .KilledByTitle:
            return "Killed By"
        default:
            return ""
        }
    }

    func dataSource(player: MatchPlayerModel) -> ScoreCollectionViewDataSource? {
        switch self {
        case .Medals:
            return MedalCellModel(medals: player.medals)
        case .Weapons:
            return WeaponCellModel(weapons: player.weapons)
        case .Stats:
            return PlayerStatsCellModel(stats: player.stats)
        case .KilledOpponents:
            return OpponentDetailCellModel(opponents: player.killedOpponents)
        case .KilledByOpponents:
            return OpponentDetailCellModel(opponents: player.killedByOpponents)
        default:
            return nil
        }
    }
}

class PlayerCarnageReportViewModel {

    let match: MatchModel
    let player: MatchPlayerModel
    var sections: [PlayerCarnageReportSection] = []

    init(match: MatchModel, player: MatchPlayerModel) {
        self.match = match
        self.player = player
        setupSections()
    }

    func setupSections() {
        var sections: [PlayerCarnageReportSection] = []

        sections += [.KDandKDA]

        if player.medals.count != 0 {
            sections += [.MedalsTitle, .Medals]
        }

        if player.mostUsedWeapon != nil {
            sections += [.MostUsedWeaponTitle, .MostUsedWeapon]
        }

        if player.weapons.count != 0 {
            sections += [.WeaponsTitle, .Weapons]
        }

        if player.killedOpponents.count != 0 {
            sections += [.KilledTitle, .KilledOpponents]
        }

        if player.killedByOpponents.count != 0 {
            sections += [.KilledByTitle, .KilledByOpponents]
        }

        sections += [.StatsTitle, .Stats]

        self.sections = sections
    }

    func saveSpartan(player: MatchPlayerModel, completion: Void -> Void) {
        guard !SpartanManager.sharedManager.spartanIsSaved(player.gamertag) else { return }
        
        let operation = DownloadSpartanDataOperation(gamertag: player.gamertag.lowercaseString) {
            SpartanManager.sharedManager.saveSpartan(player.gamertag)
            dispatch_async(dispatch_get_main_queue()) {
                completion()
            }
        }

        UIApplication.appController().operationQueue.addOperation(operation)
    }
}
