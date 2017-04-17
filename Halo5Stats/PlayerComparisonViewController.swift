//
//  PlayerComparisonViewController.swift
//  Halo5Stats
//
//  Copyright © 2015 Justin Powell. All rights reserved.
//

import UIKit
import Foundation

class PlayerComparisonViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        definesPresentationContext = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        definesPresentationContext = false
    }

    deinit {
        removeGamertagWatcher()
    }

    // MARK: - PlayerComparisonViewController

    lazy var spartansViewController = StoryboardScene.PlayerComparison.spartansViewController()

    var searchController: UISearchController!
    fileprivate let gamertagValidator = GamertagValidator()

    fileprivate func setupController(shouldSetupSearch setupSearch: Bool = true) {
        title = "Spartans"
        gamertagValidator.viewController = self
        spartansViewController.viewController = self

        embed(viewController: spartansViewController, inView: containerView)

        setupNavBar()
        if setupSearch {
            setupSearchController()
        }
    }

    fileprivate func setupNavBar() {
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTapped))
        navigationItem.leftBarButtonItem = searchButton
        navigationItem.titleView = nil
    }

    fileprivate func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self

        searchController.searchBar.placeholder = "Search for fellow Spartans"
        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.autocorrectionType = .no
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()

        setupSearchBarAppearance()
    }

    fileprivate func setupSearchBarAppearance() {
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.cinder.lighter()
         UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = .whiteSmoke
        searchController.searchBar.tintColor = .whiteSmoke
    }

    @objc fileprivate func searchButtonTapped() {
        navigationItem.leftBarButtonItem = nil
        navigationItem.titleView = searchController.searchBar
        searchController.searchBar.becomeFirstResponder()
        spartansViewController.viewModel.isSearching.value = true
    }
}

extension PlayerComparisonViewController: UISearchResultsUpdating, UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        spartansViewController.viewModel.searchButtonClicked(searchBar, validator: gamertagValidator, viewController: self)
    }

    func updateSearchResults(for searchController: UISearchController) {
        spartansViewController.viewModel.updateSearch(forSeachController: searchController)
    }
}

extension PlayerComparisonViewController: UISearchControllerDelegate {

    func willDismissSearchController(_ searchController: UISearchController) {
        setupNavBar()
        spartansViewController.viewModel.isSearching.value = false
        spartansViewController.viewModel.fetchSpartans()
    }
}

extension PlayerComparisonViewController: GamertagWatcher {

    func defaultGamertagChanged(_ notification: Notification) {
        _ = navigationController?.popToRootViewController(animated: false)
    }
}
