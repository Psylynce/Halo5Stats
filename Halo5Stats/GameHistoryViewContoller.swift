//
//  GameHistoryViewContoller.swift
//  Halo5Stats
//
//  Copyright © 2015 Justin Powell. All rights reserved.
//

import UIKit
import Foundation

class GameHistoryViewController: UIViewController, ParallaxScrollingTableView {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var refreshCustomView: UIView!
    @IBOutlet var loadingIndicator: LoadingIndicator!
    @IBOutlet var headerView: GameHistoryHeaderView!
    @IBOutlet var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var noModesSelectedLabel: UILabel!

    struct Layout {
        static let maxHeaderHeight: CGFloat = 130.0
        static let minHeaderHeight: CGFloat = 70.0
    }
    
    var viewModel = GameHistoryViewModel()
    lazy var filterMatchesViewController = StoryboardScene.GameHistory.matchFilterViewController()

    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindAndFires()
        setup()
        initializeHeader()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.presentTransparentNavigationBar()
        navigationController?.setNavigationBarHidden(true, animated: false)

        if gamertagChanged {
            let top = CGPoint(x: 0, y: 0 - tableView.contentInset.top)
            tableView.setContentOffset(top, animated: false)
            tableView.reloadData()
            gamertagChanged = false
            setupBindAndFires()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.hideTransparentNavigationBar()
    }

    deinit {
        removeGamertagWatcher()
    }
    
    // MARK: - Private

    private let refreshControl = UIRefreshControl()
    fileprivate var gamertagChanged: Bool = false

    fileprivate func setupBindAndFires() {
        viewModel.matches.bindAndFire { [weak self] (matches) in
            if let shouldInsert = self?.viewModel.shouldInsert, let indexPaths = self?.viewModel.indexPathsToInsert, shouldInsert {
                self?.tableView.insertRows(at: indexPaths as [IndexPath], with: .automatic)
            } else {
                self?.tableView.reloadData()
            }
        }
    }

    fileprivate func setup() {
        view.backgroundColor = .cinder

        tableView.separatorStyle = .none
        tableView.backgroundColor = .cinder
        tableView.dataSource = self
        tableView.delegate = self

        setupRefreshView()
        refreshControl.addTarget(self, action: #selector(refreshMatches), for: .valueChanged)

        headerView.delegate = self
        headerView.clipsToBounds = true
        viewModel.gameModes = headerView.selectedGameModes

        noModesSelectedLabel.font = UIFont.kelson(.Regular, size: 16.0)
        noModesSelectedLabel.textColor = .whiteSmoke

        updateViewForGameModes()
    }

    fileprivate func setupRefreshView() {
        tableView.backgroundView = refreshControl
        refreshCustomView.frame = refreshControl.bounds
        refreshControl.addSubview(refreshCustomView)
        refreshCustomView.backgroundColor = .clear
        refreshControl.tintColor = .clear
    }

    @objc fileprivate func refreshMatches() {
        loadingIndicator.show()
        viewModel.fetchMatches(true) { [weak self] () in
            self?.loadingIndicator.hide()
            self?.refreshControl.endRefreshing()
        }
    }

    fileprivate func updateViewForGameModes() {
        noModesSelectedLabel.isHidden = !viewModel.gameModes.isEmpty
        tableView.isHidden = viewModel.gameModes.isEmpty
        if viewModel.gameModes.isEmpty {
            expandHeader()
        }
    }

    // MARK: - ScrollingHeaderController

    var previousScrollOffset: CGFloat = 0.0
    var maxHeaderHeight: CGFloat = Layout.maxHeaderHeight
    var minHeaderHeight: CGFloat = Layout.minHeaderHeight
}

extension GameHistoryViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfMatches(forSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let match = viewModel.match(for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameHistoryCell", for: indexPath) as! GameHistoryCell
        cell.configure(match)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let match = viewModel.match(for: indexPath)
        let vc = StoryboardScene.GameHistory.carnageReportViewController()
        vc.viewModel = CarnageReportViewModel(match: match)

        navigationController?.pushViewController(vc, animated: true)
        AppReviewManager.shared.updateCount(for: .matchViewed)
    }
}

extension GameHistoryViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? GameHistoryCell {
            cellImageOffset(tableView, cell: cell, indexPath: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let indexPaths = tableView.indexPathsForVisibleRows {
            for indexPath in indexPaths {
                if let cell = tableView.cellForRow(at: indexPath) as? GameHistoryCell {
                    cellImageOffset(tableView, cell: cell, indexPath: indexPath)
                }
            }
        }
        viewModel.scrollViewDidScroll(scrollView)
        animateHeaderScroll(with: scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidStop()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewDidStop()
        }
    }
}

extension GameHistoryViewController: ScrollingHeaderController {

    var scrollView: UIScrollView! {
        return tableView
    }

    var scrollingHeaderView: ScrollingHeaderView! {
        return headerView
    }
}

extension GameHistoryViewController: GamertagWatcher {

    func defaultGamertagChanged(_ notification: Notification) {
        viewModel = GameHistoryViewModel()
        gamertagChanged = true
        navigationController?.popToRootViewController(animated: false)
    }
}

extension GameHistoryViewController: GameHistoryHeaderViewDelegate {

    func gameModeButtonTapped() {
        viewModel.gameModes = headerView.selectedGameModes

        if viewModel.gameModes.isEmpty == false {
            viewModel.fetchMatches(true) { [weak self] in
                self?.updateViewForGameModes()
                if self?.viewModel.matches.value.isEmpty == false {
                    self?.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                }
            }
        } else {
            updateViewForGameModes()
        }
    }
}
