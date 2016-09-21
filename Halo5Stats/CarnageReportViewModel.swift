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

    private func fetchCarnageReport() {
        let reports = carnageReports()
        if reports.isEmpty {
            requestCarnageReports()
        } else {
            convert(reports)
        }
    }

    private func convert(reports: [CarnageReport]) {
        guard !reports.isEmpty else { return }
        
        var newReports: [MatchPlayerModel] = []

        for report in reports {
            if let model = MatchPlayerModel.convert(report) {
                newReports.append(model)
            }
        }

        var sortedPlayers = newReports.sort { $0.rank < $1.rank }
        if match.isTeamGame {
            sortedPlayers.sortInPlace { $0.teamId < $1.teamId }
        }

        self.players.value = sortedPlayers
    }

    private func requestCarnageReports() {
        guard let path = match.match.matchPath else { return }

        let request = CarnageReportRequest(path: path)
        let operation = APIRequestOperation(request: request) {
            dispatch_async(dispatch_get_main_queue()) {
                let reports = self.carnageReports()
                self.convert(reports)
            }
        }

        UIApplication.appController().operationQueue.addOperation(operation)
    }

    private func carnageReports() -> [CarnageReport] {
        let identifier = self.match.matchId
        let predicate = NSPredicate.predicate(withIdentifier: identifier)
        let m = Match.findOrFetch(inContext: UIApplication.appController().managedObjectContext(), matchingPredicate: predicate)
        guard let match = m, reports = match.carnageReports?.allObjects as? [CarnageReport] where !reports.isEmpty else { return [] }

        return reports
    }
}
