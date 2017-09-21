//
//  ServiceRecordViewModel.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

enum ServiceRecordSection {
    case highestCSR
    case games
    case kdAndKDA
    case topMedalsTitle
    case topMedals
    case allMedals
    case mostUsedWeaponTitle
    case mostUsedWeapon
    case weapons
    case stats

    var color: UIColor? {
        switch self {
        case .games, .topMedalsTitle, .topMedals, .allMedals:
            return .elephant
        case .highestCSR, .weapons:
            return .cinder
        default:
            return nil
        }
    }

    var title: String {
        switch self {
        case .topMedalsTitle:
            return "Top Medals"
        case .mostUsedWeaponTitle:
            return "Most Used Weapon"
        case .allMedals:
            return "See Awarded Medals"
        case .weapons:
            return "All Weapon Stats"
        default:
            return ""
        }
    }

    func dataSource(_ record: ServiceRecordModel) -> ScoreCollectionViewDataSource? {
        switch self {
        case .topMedals:
            return MedalCellModel(medals: record.topMedals)
        case .stats:
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

        // Make this a method on the service record model
        if let gamertag = gamertag, let spartan = Spartan.spartan(gamertag), let cachedRecord = spartan.serviceRecord(forType: gameMode), let cachedRecordModel = ServiceRecordModel.convert(serviceRecord: cachedRecord) {
            serviceRecord.value = [cachedRecordModel]
        }

        fetchServiceRecord(force: false) {}
    }

    func fetchServiceRecord(force: Bool, completion: @escaping (Void) -> Void) {
        requestServiceRecord(force) {
            completion()
        }
    }

    func setupSections(){
        guard let record = record() else { return }
        var sections: [ServiceRecordSection] = []

        if record.highestAttainedCSR != nil {
            sections += [.highestCSR]
        }

        sections += [.games, .kdAndKDA]

        if !record.topMedals.isEmpty {
            sections += [.topMedalsTitle, .topMedals, .allMedals]
        }

        if record.mostUsedWeapon != nil {
            sections += [.mostUsedWeaponTitle, .mostUsedWeapon]
        }
        if !record.weapons.isEmpty {
            sections += [.weapons]
        }

        sections += [.stats]

        self.sections.value = sections
    }

    func record() -> ServiceRecordModel? {
        guard let record = serviceRecord.value.first, serviceRecord.value.count == 1 else { return nil }

        return record
    }

    // MARK: - Private

    fileprivate func setRecord(forSpartan spartan: Spartan) {
        guard let record = spartan.serviceRecord(forType: gameMode), let convertedRecord = ServiceRecordModel.convert(serviceRecord: record) else { return }
        DispatchQueue.main.async { [weak self] in
            self?.serviceRecord.value = [convertedRecord]
            self?.setupSections()
        }
    }

    fileprivate func requestServiceRecord(_ force: Bool, completion: @escaping (Void) -> Void) {
        guard let queue = Container.resolve(OperationQueue.self) else { return }
        guard let gamertag = self.gamertag, let spartan = Spartan.spartan(gamertag) else { return }

        let requestType = NetworkRequestManager.RequestType.requestType(forGameMode: gameMode)
        guard NetworkRequestManager.sharedManager.shouldSendRequest(requestType, force: force) else {
            setRecord(forSpartan: spartan)
            completion()
            return
        }

        let request = ServiceRecordRequest(gamertags: [gamertag], gameMode: gameMode)
        let operation = APIRequestOperation(request: request) {
            DispatchQueue.main.async { [weak self] in
                self?.setRecord(forSpartan: spartan)
                completion()
            }
        }

        queue.addOperation(operation)
    }
}
