//
//  ServiceRecordViewModel.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

enum ServiceRecordSection {
    case HighestCSR
    case Games
    case KDAndKDA
    case TopMedalsTitle
    case TopMedals
    case AllMedals
    case MostUsedWeaponTitle
    case MostUsedWeapon
    case Stats

    var color: UIColor? {
        switch self {
        case .Games, .TopMedalsTitle, .TopMedals, .AllMedals:
            return UIColor(haloColor: .Elephant)
        case .HighestCSR:
            return UIColor(haloColor: .Cinder)
        default:
            return nil
        }
    }

    func title() -> String {
        switch self {
        case .TopMedalsTitle:
            return "Top Medals"
        case .MostUsedWeaponTitle:
            return "Most Used Weapon"
        case .AllMedals:
            return "See Awarded Medals"
        default:
            return ""
        }
    }

    func dataSource(record: ServiceRecordModel) -> ScoreCollectionViewDataSource? {
        switch self {
        case .TopMedals:
            return MedalCellModel(medals: record.topMedals)
        case .Stats:
            return PlayerStatsCellModel(stats: record.stats)
        default:
            return nil
        }
    }
}

class ServiceRecordViewModel {

    let gameMode: GameMode
    let gamertag: String?
    var sections: Dynamic<[ServiceRecordSection]> = Dynamic([])

    var serviceRecord: Dynamic<[ServiceRecordModel]> = Dynamic([])

    init(gameMode: GameMode, gamertag: String?) {
        self.gameMode = gameMode
        self.gamertag = gamertag
        fetchServiceRecord(force: false) {}
    }

    func fetchServiceRecord(force force: Bool, completion: Void -> Void) {
        requestServiceRecord(force) {
            completion()
        }
    }

    func setupSections(){
        guard let record = record() else { return }
        var sections: [ServiceRecordSection] = []

        if record.highestAttainedCSR != nil {
            sections += [.HighestCSR]
        }

        sections += [.Games, .KDAndKDA]

        if !record.topMedals.isEmpty {
            sections += [.TopMedalsTitle, .TopMedals, .AllMedals]
        }

        if record.mostUsedWeapon != nil {
            sections += [.MostUsedWeaponTitle, .MostUsedWeapon]
        }

        sections += [.Stats]

        self.sections.value = sections
    }

    func record() -> ServiceRecordModel? {
        guard let record = serviceRecord.value.first where serviceRecord.value.count == 1 else { return nil }

        return record
    }

    // MARK: - Private

    private func setRecord(forSpartan spartan: Spartan) {
        guard let record = spartan.serviceRecord(forType: gameMode.rawValue), convertedRecord = ServiceRecordModel.convert(serviceRecord: record) else { return }
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            self?.serviceRecord.value = [convertedRecord]
            self?.setupSections()
        }
    }

    private func requestServiceRecord(force: Bool, completion: Void -> Void) {
        guard let gamertag = self.gamertag, spartan = Spartan.spartan(gamertag) else { return }

        let requestType = NetworkRequestManager.RequestType.requestType(forGameMode: gameMode)
        guard NetworkRequestManager.sharedManager.shouldSendRequest(requestType, force: force) else {
            setRecord(forSpartan: spartan)
            completion()
            return
        }

        let request = ServiceRecordRequest(gamertags: [gamertag], gameMode: gameMode)
        let operation = APIRequestOperation(request: request) {
            dispatch_async(dispatch_get_main_queue()) { [weak self] in
                self?.setRecord(forSpartan: spartan)
                completion()
            }
        }

        UIApplication.appController().operationQueue.addOperation(operation)
    }
}
