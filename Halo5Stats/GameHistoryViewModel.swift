//
//  GameHistoryViewModel.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class GameHistoryViewModel {

    let gamertag: String?

    var matches: Dynamic<[MatchModel]> = Dynamic([])
    var isFiltering: Dynamic<Bool> = Dynamic(false)
    var filteredMatches: Dynamic<[MatchModel]> = Dynamic([])
    var isEndOfMatches: Bool = false
    var matchIds: [String] = []

    var currentStartIndex: Int = 0
    var isFetching: Bool = false
    var shouldInsert: Bool = false
    var indexPathsToInsert: [IndexPath] = []

    init(gamertag: String?) {
        self.gamertag = gamertag
        updateMapMetadata { [weak self] in
            self?.fetchMatches() {}
        }
    }

    convenience init() {
        let gamertag = GamertagManager.sharedManager.gamertagForUser()
        self.init(gamertag: gamertag)
    }

    func fetchMatches(_ isRefresh: Bool = false, completion: @escaping (Void) -> Void) {
        guard let gamertag = gamertag, let spartan = Spartan.spartan(gamertag), isFetching == false else {
            completion()
            return
        }

        if isRefresh {
            currentStartIndex = 0
            matchIds = []
        }
        isFetching = true

        requestMatches(gamertag) {
            DispatchQueue.main.async { [weak self] in
                self?.updateMatches(forSpartan: spartan, isRefresh: isRefresh)
                self?.isFetching = false
                completion()
            }
        }
    }

    func updateMatches(forSpartan spartan: Spartan, isRefresh: Bool) {
        let newMatchIds = Array(matchIds[currentStartIndex ..< matchIds.count])

        let context = UIApplication.appController().managedObjectContext()
        let fetchedMatches = Match.sortedMatches(withIdentifiers: newMatchIds, in: context)
        let newMatches = fetchedMatches.flatMap { MatchModel.convert($0) }

        currentStartIndex = matchIds.count
        if isRefresh {
            shouldInsert = false
            matches.value = newMatches
        } else {
            shouldInsert = true
            updateIndexPaths(newMatches.count)
            matches.value += newMatches
        }

        shouldInsert = false
    }

    func updateIndexPaths(_ newMatches: Int) {
        indexPathsToInsert = []
        for i in currentStartIndex - newMatches ..< currentStartIndex {
            let indexPath = IndexPath(row: i, section: 0)
            indexPathsToInsert.append(indexPath)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isEndOfMatches else { return }

        let maxOffset = scrollView.contentSize.height - scrollView.frame.height
        let currentOffset = scrollView.contentOffset.y
        let percentage = Int(currentOffset * 100 / maxOffset)

        if percentage >= 60 && !isFiltering.value {
            fetchMatches() {}
        }
    }

    func numberOfMatches(forSection section: Int) -> Int {
        if isFiltering.value {
            return filteredMatches.value.count
        } else {
            return matches.value.count
        }
    }

    func match(for indexPath: IndexPath) -> MatchModel {
        if isFiltering.value {
            return filteredMatches.value[indexPath.row]
        } else {
            return matches.value[indexPath.row]
        }
    }

    // MARK: - Private

    fileprivate func updateMapMetadata(_ completion: @escaping (Void) -> Void) {
        let mapsRequest = MetadataRequest(metadataType: .Maps)
        let operation = APIRequestOperation(request: mapsRequest, completion: completion)

        UIApplication.appController().operationQueue.addOperation(operation)
    }

    fileprivate func requestMatches(_ gamertag: String, completion: @escaping (Void) -> Void) {
        let params = [APIConstants.MatchesStart : "\(currentStartIndex)",
                      APIConstants.MatchesModes : GameMode.multiplayerModes()]
        let matchesRequest = MatchesRequest(gamertag: gamertag, parameters: params)
        let operation = APIRequestOperation(request: matchesRequest) { [weak self] () in
            if let data = matchesRequest.data {
                self?.updateMatchIds(with: data)
                completion()
            }
        }

        UIApplication.appController().operationQueue.addOperation(operation)
    }

    fileprivate func updateMatchIds(with data: [String : AnyObject]) {
        if currentStartIndex == 0 {
            matchIds = []
        }

        guard let matches = data[JSONKeys.Matches.matches] as? [AnyObject] else { return }
        isEndOfMatches = matches.count == 0
        for match in matches {
            guard let id = match[JSONKeys.Identifier] as? [String : AnyObject] else { continue }
            guard let matchId = id[JSONKeys.Matches.matchId] as? String, !matchIds.contains(matchId) else { continue }
            matchIds.append(matchId)
        }
    }
}

extension GameHistoryViewModel: MatchFilterDelegate {

    func applyFilters(_ model: MatchFilterViewModel) {
        isFiltering.value = model.isFiltered()
        let allMatches = matches.value
        var filteredMatches: [MatchModel] = []

        if model.arenaSelected.value {
            filteredMatches += allMatches.filter {
                $0.gameMode == .Arena
            }
        }

        if model.warzoneSelected.value {
            filteredMatches += allMatches.filter {
                $0.gameMode == .Warzone
            }
        }

        if model.customsSelected.value {
            filteredMatches += allMatches.filter {
                $0.gameMode == .Custom
            }
        }

        self.filteredMatches.value = filteredMatches
    }
}
