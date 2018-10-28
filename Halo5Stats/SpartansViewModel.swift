//
//  SpartansViewModel.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

enum SpartanSection {
    case `default`
    case favorites
    case spartans
    case filtered

    var title: String? {
        switch  self {
        case .default:
            return "You"
        case .favorites:
            return "Favorites"
        case .spartans:
            return "Fellow Spartans"
        case .filtered:
            return nil
        }
    }
}

protocol SpartansViewModelDelegate: class {
    func searchStarted()
    func searchEnded()
}

class SpartansViewModel {

    var sections: Dynamic<[SpartanSection]> = Dynamic([])
    var defaultSpartan: Dynamic<[SpartanModel]> = Dynamic([])
    var favorites: Dynamic<[SpartanModel]> = Dynamic([])
    var spartans: Dynamic<[SpartanModel]> = Dynamic([])
    var selectedSpartans: Dynamic<[SpartanModel]> = Dynamic([])
    var filteredSpartans: Dynamic<[SpartanModel]> = Dynamic([])
    var isSearching: Dynamic<Bool> = Dynamic(false)

    weak var delegate: SpartansViewModelDelegate?

    func fetchSpartans() {
        guard let controller = Container.resolve(PersistenceController.self) else { return }

        let spartans = Spartan.fetch(inContext: controller.managedObjectContext)
        let newSpartans = spartans.compactMap { SpartanModel.convert($0) }

        self.filteredSpartans.value = sortSpartans(newSpartans)

        let defaultSpartan = newSpartans.filter { spartan in
            guard let defaultGT = GamertagManager.sharedManager.gamertagForUser() else { return false }
            return spartan.gamertag == defaultGT
        }
        self.defaultSpartan.value = defaultSpartan

        let filteredSpartans = newSpartans.filter { spartan in
            guard let defaultGT = GamertagManager.sharedManager.gamertagForUser() else { return false }
            return spartan.gamertag != defaultGT
        }

        let favorites = filteredSpartans.filter { spartan in
            return FavoritesManager.sharedManager.isFavorite(spartan.gamertag)
        }
        self.favorites.value = sortSpartans(favorites)

        let s = filteredSpartans.filter { spartan in
            return FavoritesManager.sharedManager.isFavorite(spartan.gamertag) == false
        }
        self.spartans.value = sortSpartans(s)

        updateSections()
    }

    func updateSearch(forSeachController sc: UISearchController) {
        guard let searchText = sc.searchBar.text, !searchText.isEmpty else {
            fetchSpartans()
            return
        }

        let filteredSpartans = self.filteredSpartans.value.filter { spartan in
            return spartan.gamertag.lowercased().contains(searchText.lowercased())
        }

        self.filteredSpartans.value = filteredSpartans
    }

    func searchButtonClicked(_ searchBar: UISearchBar, validator: GamertagValidator, viewController: PlayerComparisonViewController) {
        searchBar.resignFirstResponder()
        if let gamertag = searchBar.text {
            guard !SpartanManager.sharedManager.spartanIsSaved(gamertag) else {
                viewController.showAlreadySavedAlert()
                return
            }

            delegate?.searchStarted()
            validator.validate(gamertag) { [weak self] (success) in
                self?.delegate?.searchEnded()
                if success {
                    SpartanManager.sharedManager.saveSpartan(gamertag)
                    let serviceRecordParentVC = StoryboardScene.PlayerStats.playerStatsParentViewController()
                    serviceRecordParentVC.viewModel = PlayerStatsParentViewModel(gamertag: gamertag)

                    viewController.navigationController?.pushViewController(serviceRecordParentVC, animated: true)
                    viewController.hideBackButtonTitle()
                    viewController.searchController.isActive = false
                }
            }
        }
    }

    func isComparing(_ spartan: SpartanModel) -> Bool {
        return selectedSpartans.value.contains(where: { $0.gamertag == spartan.gamertag })
    }

    func spartan(forIndexPath indexPath: IndexPath) -> SpartanModel {
        let section = sections.value[indexPath.section]
        var spartan: SpartanModel

        switch section {
        case .default:
            spartan = defaultSpartan.value[indexPath.row]
        case .favorites:
            spartan = favorites.value[indexPath.row]
        case .spartans:
            spartan = spartans.value[indexPath.row]
        case .filtered:
            spartan = filteredSpartans.value[indexPath.row]
        }

        return spartan
    }

    // MARK: - Private

    fileprivate func updateSections() {
        var newSections: [SpartanSection] = []

        if isSearching.value {
            sections.value = [.filtered]
            return
        }

        if defaultSpartan.value.count == 1 {
            newSections.append(.default)
        }

        if favorites.value.count > 0 {
            newSections.append(.favorites)
        }

        if spartans.value.count > 0 {
            newSections.append(.spartans)
        }

        sections.value = newSections
    }

    fileprivate func sortSpartans(_ spartans: [SpartanModel]) -> [SpartanModel] {
        return spartans.sorted { $0.displayGamertag.lowercased() < $1.displayGamertag.lowercased() }
    }
}

extension SpartansViewModel: SpartanCellDelegate {

    func compareButtonTapped(_ spartan: SpartanModel) {
        if let index = selectedSpartans.value.index(where: { $0.gamertag == spartan.gamertag }) {
            selectedSpartans.value.remove(at: index)
        } else {
            selectedSpartans.value.append(spartan)
        }
    }

    func favoriteButtonTapped(_ cell: SpartanCell) {
        fetchSpartans()
    }
}
