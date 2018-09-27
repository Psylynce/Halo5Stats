//
//  CarnageReportViewController.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation
import UIKit

enum CarnageReportSection: Int {
    case image = 0
    case scores
    case teamTitle
    case teams

    static let sections = [image, scores, teamTitle, teams]
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.presentTransparentNavigationBar()
        hideBackButtonTitle()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.hideTransparentNavigationBar()
    }

    fileprivate func setupAppearance() {
        view.backgroundColor = UIColor.black
        tableView.separatorStyle = .none
    }
}

extension CarnageReportViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return CarnageReportSection.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = CarnageReportSection(rawValue: section) else { return 0 }

        switch  section {
        case .image, .scores, .teamTitle:
            return 1
        case .teams:
            return viewModel.players.value.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = CarnageReportSection(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .image:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageCell

            if !viewModel.match.isTeamGame && !viewModel.players.value.isEmpty {
                cell.configure(viewModel.match, player: viewModel.players.value[0])
            } else {
                cell.configure(viewModel.match)
            }

            return cell
        case .scores:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionViewTableViewCell", for: indexPath) as! CollectionViewTableViewCell
            cell.dataSource = CarnageReportScoreCellModel(match: viewModel.match, teams: viewModel.match.teams, players: viewModel.players.value)

            return cell
        case .teamTitle:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerStatTitleCell", for: indexPath) as! PlayerStatTitleCell
            return cell
        case .teams:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerStatsCell", for: indexPath) as! PlayerStatsCell
            let player = viewModel.players.value[indexPath.row]
            cell.configure(player, isTeamGame: viewModel.match.isTeamGame)

            return cell
        }

    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = CarnageReportSection(rawValue: indexPath.section) else { return 0 }

        switch section {
        case .image:
            return UITableView.automaticDimension
        case .scores:
            let showTeams = viewModel.match.isTeamGame
            return showTeams ? 100.0 : 130.0
        case .teamTitle, .teams:
            return 50.0
        }
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = CarnageReportSection(rawValue: indexPath.section) else { return 0 }

        switch section {
        case .image:
            return 200.0
        default:
            return 100.0
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = CarnageReportSection(rawValue: indexPath.section) else { return }

        switch  section {
        case .teams:
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

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ImageCell {
            cell.scrollViewDidScroll(scrollView)
        }
    }
}
