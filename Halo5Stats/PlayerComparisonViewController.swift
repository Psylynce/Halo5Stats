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

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        definesPresentationContext = true
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        definesPresentationContext = false
    }

    deinit {
        removeGamertagWatcher()
    }

    // MARK: - PlayerComparisonViewController

    lazy var spartansViewController = StoryboardScene.PlayerComparison.spartansViewController()

    var searchController: UISearchController!
    private let gamertagValidator = GamertagValidator()

    private func setupController(shouldSetupSearch setupSearch: Bool = true) {
        title = "Spartans"
        gamertagValidator.viewController = self
        spartansViewController.viewController = self

        embed(viewController: spartansViewController, inView: containerView)

        setupNavBar()
        if setupSearch {
            setupSearchController()
        }
    }

    private func setupNavBar() {
        let searchButton = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: #selector(searchButtonTapped))
        navigationItem.leftBarButtonItem = searchButton
        navigationItem.titleView = nil
    }

    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self

        searchController.searchBar.placeholder = "Search for fellow Spartans"
        searchController.searchBar.searchBarStyle = .Prominent
        searchController.searchBar.autocorrectionType = .No
        searchController.searchBar.autocapitalizationType = .None
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()

        setupSearchBarAppearance()
    }

    private func setupSearchBarAppearance() {
        UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).backgroundColor = UIColor(haloColor: .Cinder).lighter()
         UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).textColor = UIColor(haloColor: .WhiteSmoke)
        searchController.searchBar.tintColor = UIColor(haloColor: .WhiteSmoke)
    }

    @objc private func searchButtonTapped() {
        navigationItem.leftBarButtonItem = nil
        navigationItem.titleView = searchController.searchBar
        searchController.searchBar.becomeFirstResponder()
        spartansViewController.viewModel.isSearching.value = true
    }
}

extension PlayerComparisonViewController: UISearchResultsUpdating, UISearchBarDelegate {

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        spartansViewController.viewModel.searchButtonClicked(searchBar, validator: gamertagValidator, viewController: self)
    }

    func updateSearchResultsForSearchController(searchController: UISearchController) {
        spartansViewController.viewModel.updateSearch(forSeachController: searchController)
    }
}

extension PlayerComparisonViewController: UISearchControllerDelegate {

    func willDismissSearchController(searchController: UISearchController) {
        setupNavBar()
        spartansViewController.viewModel.isSearching.value = false
        spartansViewController.viewModel.fetchSpartans()
    }
}

extension PlayerComparisonViewController: GamertagWatcher {

    func defaultGamertagChanged(notification: NSNotification) {
        navigationController?.popToRootViewControllerAnimated(false)
    }
}
