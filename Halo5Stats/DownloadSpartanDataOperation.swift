//
//  DownloadSpartanDataOperation.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class DownloadSpartanDataOperation: GroupOperation {

    let setupSpartanOperation: SetupSpartanOperation
    let downloadArenaOperation: APIRequestOperation
    let downloadWarzoneOperation: APIRequestOperation
    let downloadCustomOperation: APIRequestOperation
    let downloadMatchesOperation: APIRequestOperation

    init(gamertag: String, completion: @escaping () -> Void) {
        setupSpartanOperation = SetupSpartanOperation(gamertag: gamertag)

        let arenaRequest = ServiceRecordRequest(gamertags: [gamertag], gameMode: .Arena)
        downloadArenaOperation = APIRequestOperation(request: arenaRequest) {
            print("Arena parsed for \(gamertag)")
        }

        let warzoneRequest = ServiceRecordRequest(gamertags: [gamertag], gameMode: .Warzone)
        downloadWarzoneOperation = APIRequestOperation(request: warzoneRequest) {
            print("Warzone parsed for \(gamertag)")
        }

        let customsRequest = ServiceRecordRequest(gamertags: [gamertag], gameMode: .Custom)
        downloadCustomOperation = APIRequestOperation(request: customsRequest) {
            print("Custom parsed for \(gamertag)")
        }

        let matchesRequest = MatchesRequest(gamertag: gamertag)
        downloadMatchesOperation = APIRequestOperation(request: matchesRequest) {
            print("Initial matches parsed for \(gamertag)")
        }

        let finishOperation = Foundation.BlockOperation(block: completion)

        downloadArenaOperation.addDependency(setupSpartanOperation)
        downloadWarzoneOperation.addDependency(downloadArenaOperation)
        downloadCustomOperation.addDependency(downloadWarzoneOperation)
        downloadMatchesOperation.addDependency(downloadCustomOperation)
        finishOperation.addDependency(downloadMatchesOperation)

        let operations: [Foundation.Operation] = [setupSpartanOperation, downloadArenaOperation, downloadWarzoneOperation, downloadCustomOperation, downloadMatchesOperation, finishOperation]

        super.init(operations: operations)

        name = "Download Spartan Data for \(gamertag)"
    }
}
