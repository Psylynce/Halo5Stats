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
//        filterButton.tintColor = UIColor(haloColor: .WhiteSmoke)
//        navigationItem.rightBarButtonItem = filterButton
    }

    override func viewWillAppear(animated: Bool) {
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

    private var gamertagChanged: Bool = false

    private func setupBindAndFires() {
        viewModel.matches.bindAndFire { [weak self] (matches) in
            if let shouldInsert = self?.viewModel.shouldInsert, indexPaths = self?.viewModel.indexPathsToInsert, isFiltering = self?.viewModel.isFiltering.value where shouldInsert && !isFiltering {
                self?.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
            } else {
                self?.tableView.reloadData()
            }
        }

        viewModel.filteredMatches.bindAndFire { [weak self] (matches) in
            dispatch_async(dispatch_get_main_queue()) {
                self?.tableView.reloadData()
            }
        }
    }

    private func setupTableView() {
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor(haloColor: .Cinder)
        setupRefreshView()
        refreshControl?.addTarget(self, action: #selector(refreshMatches), forControlEvents: .ValueChanged)
    }

    private func setupRefreshView() {
        guard let refreshControl = refreshControl else { return }
        refreshCustomView.frame = refreshControl.bounds
        refreshControl.addSubview(refreshCustomView)
        refreshCustomView.backgroundColor = UIColor.clearColor()
        refreshControl.tintColor = UIColor.clearColor()
    }

//    @objc private func filterButtonTapped() {
//        filterMatchesViewController.modalPresentationStyle = .OverFullScreen
//        filterMatchesViewController.viewModel.delegate = viewModel
//        presentViewController(filterMatchesViewController, animated: false) {}
//    }

    @objc private func refreshMatches() {
        loadingIndicator.show()
        viewModel.fetchMatches(true) { [weak self] () in
            self?.loadingIndicator.hide()
            self?.refreshControl?.endRefreshing()
        }
    }

    // MARK: TableView Methods

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfMatches(forSection: section)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let match = viewModel.match(forIndexPath: indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier("GameHistoryCell", forIndexPath: indexPath) as! GameHistoryCell
        cell.configure(match)

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let match = viewModel.match(forIndexPath: indexPath)
        let vc = StoryboardScene.GameHistory.carnageReportViewController()
        vc.viewModel = CarnageReportViewModel(match: match)

        navigationController?.pushViewController(vc, animated: true)
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = cell as? GameHistoryCell {
            cellImageOffset(tableView, cell: cell, indexPath: indexPath)
        }
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150.0
    }
}

extension GameHistoryViewController: GamertagWatcher {

    func defaultGamertagChanged(notification: NSNotification) {
        viewModel = GameHistoryViewModel()
        gamertagChanged = true
        setupBindAndFires()
        navigationController?.popToRootViewControllerAnimated(false)
    }
}

extension GameHistoryViewController {

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if let indexPaths = tableView.indexPathsForVisibleRows {
            for indexPath in indexPaths {
                if let cell = tableView.cellForRowAtIndexPath(indexPath) as? GameHistoryCell {
                    cellImageOffset(tableView, cell: cell, indexPath: indexPath)
                }
            }
        }
        viewModel.scrollViewDidScroll(scrollView)
    }
}
