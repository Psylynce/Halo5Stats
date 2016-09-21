//
//  CarnageReportViewController.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation
import UIKit

enum CarnageReportSection: Int {
    case Image = 0
    case Scores
    case TeamTitle
    case Teams

    static let sections = [Image, Scores, TeamTitle, Teams]
}

class CarnageReportViewController: UITableViewController {

    var viewModel: CarnageReportViewModel! {
        didSet {
            viewModel.players.bindAndFire { [weak self] (_) in
                self?.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupAppearance()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.presentTransparentNavigationBar()
        hideBackButtonTitle()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.hideTransparentNavigationBar()
    }

    private func setupAppearance() {
        view.backgroundColor = UIColor.blackColor()
        tableView.separatorStyle = .None
    }
}

extension CarnageReportViewController {

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return CarnageReportSection.sections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = CarnageReportSection(rawValue: section) else { return 0 }

        switch  section {
        case .Image, .Scores, .TeamTitle:
            return 1
        case .Teams:
            return viewModel.players.value.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let section = CarnageReportSection(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .Image:
            let cell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath) as! ImageCell

            if !viewModel.match.isTeamGame && !viewModel.players.value.isEmpty {
                cell.configure(viewModel.match, player: viewModel.players.value[0])
            } else {
                cell.configure(viewModel.match)
            }

            return cell
        case .Scores:
            let cell = tableView.dequeueReusableCellWithIdentifier("CollectionViewTableViewCell", forIndexPath: indexPath) as! CollectionViewTableViewCell
            cell.dataSource = CarnageReportScoreCellModel(match: viewModel.match, teams: viewModel.match.teams, players: viewModel.players.value)

            return cell
        case .TeamTitle:
            let cell = tableView.dequeueReusableCellWithIdentifier("PlayerStatTitleCell", forIndexPath: indexPath) as! PlayerStatTitleCell
            return cell
        case .Teams:
            let cell = tableView.dequeueReusableCellWithIdentifier("PlayerStatsCell", forIndexPath: indexPath) as! PlayerStatsCell
            let player = viewModel.players.value[indexPath.row]
            cell.configure(player, isTeamGame: viewModel.match.isTeamGame)

            return cell
        }

    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        guard let section = CarnageReportSection(rawValue: indexPath.section) else { return 0 }

        switch section {
        case .Image:
            return UITableViewAutomaticDimension
        case .Scores:
            let showTeams = viewModel.match.isTeamGame
            return showTeams ? 100.0 : 130.0
        case .TeamTitle, .Teams:
            return 50.0
        }
    }

    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        guard let section = CarnageReportSection(rawValue: indexPath.section) else { return 0 }

        switch section {
        case .Image:
            return 200.0
        default:
            return 100.0
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let section = CarnageReportSection(rawValue: indexPath.section) else { return }

        switch  section {
        case .Teams:
            let player = viewModel.players.value[indexPath.row]
            let playerCarnageReportViewController = StoryboardScene.GameHistory.playerCarnageReportViewController()
            playerCarnageReportViewController.viewModel = PlayerCarnageReportViewModel(match: viewModel.match, player: player)

            navigationController?.pushViewController(playerCarnageReportViewController, animated: true)
        default:
            return
        }
    }
}

// MARK: - UIScrollViewDelegate

extension CarnageReportViewController {

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? ImageCell {
            cell.scrollViewDidScroll(scrollView)
        }
    }
}
