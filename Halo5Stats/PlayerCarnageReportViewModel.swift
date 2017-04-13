//
//  PlayerCarnageReportViewModel.swift
//  Halo5Stats
//
//  Created by Justin Powell on 4/19/16.
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

enum PlayerCarnageReportSection {
    case kDandKDA
    case medalsTitle
    case medals
    case mostUsedWeaponTitle
    case mostUsedWeapon
    case weaponsTitle
    case weapons
    case statsTitle
    case stats
    case killedTitle
    case killedOpponents
    case killedByTitle
    case killedByOpponents

    func title() -> String {
        switch self {
        case .medalsTitle:
            return "Medals Earned"
        case .mostUsedWeaponTitle:
            return "Tool of Destruction"
        case .weaponsTitle:
            return "Weapons Used"
        case .statsTitle:
            return "Match Stats"
        case .killedTitle:
            return "Killed"
        case .killedByTitle:
            return "Killed By"
        default:
            return ""
        }
    }

    func dataSource(_ player: MatchPlayerModel) -> ScoreCollectionViewDataSource? {
        switch self {
        case .medals:
            return MedalCellModel(medals: player.medals)
        case .weapons:
            return WeaponCellModel(weapons: player.weapons)
        case .stats:
            return PlayerStatsCellModel(stats: player.stats)
        case .killedOpponents:
            return OpponentDetailCellModel(opponents: player.killedOpponents)
        case .killedByOpponents:
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

        sections += [.kDandKDA]

        if player.medals.count != 0 {
            sections += [.medalsTitle, .medals]
        }

        if player.mostUsedWeapon != nil {
            sections += [.mostUsedWeaponTitle, .mostUsedWeapon]
        }

        if player.weapons.count != 0 {
            sections += [.weaponsTitle, .weapons]
        }

        if player.killedOpponents.count != 0 {
            sections += [.killedTitle, .killedOpponents]
        }

        if player.killedByOpponents.count != 0 {
            sections += [.killedByTitle, .killedByOpponents]
        }

        sections += [.statsTitle, .stats]

        self.sections = sections
    }

    func saveSpartan(_ player: MatchPlayerModel, completion: @escaping (Void) -> Void) {
        guard !SpartanManager.sharedManager.spartanIsSaved(player.gamertag) else { return }
        guard let queue = Container.resolve(OperationQueue.self) else { return }
        
        let operation = DownloadSpartanDataOperation(gamertag: player.gamertag.lowercased()) {
            SpartanManager.sharedManager.saveSpartan(player.gamertag)
            DispatchQueue.main.async {
                completion()
            }
        }

        queue.addOperation(operation)
    }
}
