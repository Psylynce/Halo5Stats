//
//  SpartansViewModel.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

enum SpartanSection {
    case Default
    case Favorites
    case Spartans
    case Filtered

    var title: String? {
        switch  self {
        case .Default:
            return "You"
        case .Favorites:
            return "Favorites"
        case .Spartans:
            return "Fellow Spartans"
        case .Filtered:
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
        let context = UIApplication.appController().managedObjectContext()
        let spartans = Spartan.fetch(inContext: context)

        var newSpartans: [SpartanModel] = []

        for spartan in spartans {
            if let model = SpartanModel.convert(spartan) {
                newSpartans.append(model)
            }
        }

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
        guard let searchText = sc.searchBar.text where !searchText.isEmpty else {
            fetchSpartans()
            return
        }

        let filteredSpartans = self.filteredSpartans.value.filter { spartan in
            return spartan.gamertag.lowercaseString.containsString(searchText.lowercaseString)
        }

        self.filteredSpartans.value = filteredSpartans
    }

    func searchButtonClicked(searchBar: UISearchBar, validator: GamertagValidator, viewController: PlayerComparisonViewController) {
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
                    viewController.searchController.active = false
                }
            }
        }
    }

    func isComparing(spartan: SpartanModel) -> Bool {
        return selectedSpartans.value.contains({ $0.gamertag == spartan.gamertag })
    }

    func spartan(forIndexPath indexPath: NSIndexPath) -> SpartanModel {
        let section = sections.value[indexPath.section]
        var spartan: SpartanModel

        switch section {
        case .Default:
            spartan = defaultSpartan.value[indexPath.row]
        case .Favorites:
            spartan = favorites.value[indexPath.row]
        case .Spartans:
            spartan = spartans.value[indexPath.row]
        case .Filtered:
            spartan = filteredSpartans.value[indexPath.row]
        }

        return spartan
    }

    // MARK: - Private

    private func updateSections() {
        var newSections: [SpartanSection] = []

        if isSearching.value {
            sections.value = [.Filtered]
            return
        }

        if defaultSpartan.value.count == 1 {
            newSections.append(.Default)
        }

        if favorites.value.count > 0 {
            newSections.append(.Favorites)
        }

        if spartans.value.count > 0 {
            newSections.append(.Spartans)
        }

        sections.value = newSections
    }

    private func sortSpartans(spartans: [SpartanModel]) -> [SpartanModel] {
        return spartans.sort { $0.displayGamertag.lowercaseString < $1.displayGamertag.lowercaseString }
    }
}

extension SpartansViewModel: SpartanCellDelegate {

    func compareButtonTapped(spartan: SpartanModel) {
        if let index = selectedSpartans.value.indexOf({ $0.gamertag == spartan.gamertag }) {
            selectedSpartans.value.removeAtIndex(index)
        } else {
            selectedSpartans.value.append(spartan)
        }
    }

    func favoriteButtonTapped(cell: SpartanCell) {
        fetchSpartans()
    }
}
