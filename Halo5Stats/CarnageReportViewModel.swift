//
//  CarnageReportViewModel.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class CarnageReportViewModel {

    var match: MatchModel
    var players: Dynamic<[MatchPlayerModel]> = Dynamic([])

    init(match: MatchModel) {
        self.match = match
        fetchCarnageReport()
    }

    fileprivate func fetchCarnageReport() {
        let reports = carnageReports()
        if reports.isEmpty {
            requestCarnageReports()
        } else {
            convert(reports)
        }
    }

    fileprivate func convert(_ reports: [CarnageReport]) {
        guard !reports.isEmpty else { return }

        let newReports = reports.flatMap { MatchPlayerModel.convert($0) }
        var sortedPlayers = newReports.sorted { $0.rank < $1.rank }
        
        if match.isTeamGame {
            sortedPlayers.sort { $0.teamId < $1.teamId }
        }

        self.players.value = sortedPlayers
    }

    fileprivate func requestCarnageReports() {
        guard let path = match.match.matchPath else { return }

        let request = CarnageReportRequest(path: path)
        let operation = APIRequestOperation(request: request) {
            DispatchQueue.main.async {
                let reports = self.carnageReports()
                self.convert(reports)
            }
        }

        UIApplication.appController().operationQueue.addOperation(operation)
    }

    fileprivate func carnageReports() -> [CarnageReport] {
        let identifier = self.match.matchId
        let predicate = NSPredicate.predicate(withIdentifier: identifier)
        let m = Match.findOrFetch(inContext: UIApplication.appController().managedObjectContext(), matchingPredicate: predicate)
        guard let match = m, let reports = match.carnageReports?.allObjects as? [CarnageReport], !reports.isEmpty else { return [] }

        return reports
    }
}
