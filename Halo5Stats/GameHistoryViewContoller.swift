//
//  GameHistoryViewContoller.swift
//  Halo5Stats
//
//  Copyright © 2015 Justin Powell. All rights reserved.
//

import UIKit
import Foundation

class GameHistoryViewController: UITableViewController, ParallaxScrollingTableView {

    @IBOutlet var refreshCustomView: UIView!
    @IBOutlet var loadingIndicator: LoadingIndicator!
    
    var viewModel = GameHistoryViewModel()
    lazy var filterMatchesViewController = StoryboardScene.GameHistory.matchFilterViewController()

    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindAndFires()
        setupTableView()

        // ATTENTION: This will be added back in a future update when I have more filters

//        let filterButtonImage = UIImage(named: "Filter")?.imageWithRenderingMode(.AlwaysTemplate)
//        let filterButton = UIBarButtonItem(image: filterButtonImage, style: .Plain, target: self, action: #selector(filterButtonTapped))
//        filterButton.tintColor = .whiteSmoke
//        navigationItem.rightBarButtonItem = filterButton
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.title = "Game History"

        if gamertagChanged {
            let top = CGPoint(x: 0, y: 0 - tableView.contentInset.top)
            tableView.setContentOffset(top, animated: false)
            tableView.reloadData()
            gamertagChanged = false
        }
    }

    deinit {
        removeGamertagWatcher()
    }
    
    // MARK: - Private

    fileprivate var gamertagChanged: Bool = false

    fileprivate func setupBindAndFires() {
        viewModel.matches.bindAndFire { [weak self] (matches) in
            if let shouldInsert = self?.viewModel.shouldInsert, let indexPaths = self?.viewModel.indexPathsToInsert, let isFiltering = self?.viewModel.isFiltering.value, shouldInsert && !isFiltering {
                self?.tableView.insertRows(at: indexPaths as [IndexPath], with: .automatic)
            } else {
                self?.tableView.reloadData()
            }
        }

        viewModel.filteredMatches.bindAndFire { [weak self] (matches) in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    fileprivate func setupTableView() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = .cinder
        setupRefreshView()
        refreshControl?.addTarget(self, action: #selector(refreshMatches), for: .valueChanged)
    }

    fileprivate func setupRefreshView() {
        guard let refreshControl = refreshControl else { return }
        refreshCustomView.frame = refreshControl.bounds
        refreshControl.addSubview(refreshCustomView)
        refreshCustomView.backgroundColor = UIColor.clear
        refreshControl.tintColor = UIColor.clear
    }

//    @objc private func filterButtonTapped() {
//        filterMatchesViewController.modalPresentationStyle = .OverFullScreen
//        filterMatchesViewController.viewModel.delegate = viewModel
//        presentViewController(filterMatchesViewController, animated: false) {}
//    }

    @objc fileprivate func refreshMatches() {
        loadingIndicator.show()
        viewModel.fetchMatches(true) { [weak self] () in
            self?.loadingIndicator.hide()
            self?.refreshControl?.endRefreshing()
        }
    }

    // MARK: TableView Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfMatches(forSection: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let match = viewModel.match(for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameHistoryCell", for: indexPath) as! GameHistoryCell
        cell.configure(match)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let match = viewModel.match(for: indexPath)
        let vc = StoryboardScene.GameHistory.carnageReportViewController()
        vc.viewModel = CarnageReportViewModel(match: match)

        navigationController?.pushViewController(vc, animated: true)
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? GameHistoryCell {
            cellImageOffset(tableView, cell: cell, indexPath: indexPath)
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
}

extension GameHistoryViewController: GamertagWatcher {

    func defaultGamertagChanged(_ notification: Notification) {
        viewModel = GameHistoryViewModel()
        gamertagChanged = true
        setupBindAndFires()
        _ = navigationController?.popToRootViewController(animated: false)
    }
}

extension GameHistoryViewController {

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let indexPaths = tableView.indexPathsForVisibleRows {
            for indexPath in indexPaths {
                if let cell = tableView.cellForRow(at: indexPath) as? GameHistoryCell {
                    cellImageOffset(tableView, cell: cell, indexPath: indexPath)
                }
            }
        }
        viewModel.scrollViewDidScroll(scrollView)
    }
}
