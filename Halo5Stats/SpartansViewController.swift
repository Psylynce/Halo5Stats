//
//  SpartansViewController.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class SpartansViewController: UITableViewController {

    var viewController: PlayerComparisonViewController!
    var viewModel = SpartansViewModel()

    @IBOutlet var loadingView: UIView!
    @IBOutlet var loadingIndicator: LoadingIndicator!
    @IBOutlet var loadingLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupBindAndFires()
        setupAppearance()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.fetchSpartans()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel.sections.value.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = viewModel.sections.value[section]

        switch  section {
        case .Favorites:
            return viewModel.favorites.value.count
        case .Spartans:
            return viewModel.spartans.value.count
        case .Filtered:
            return viewModel.filteredSpartans.value.count
        default:
            return 1
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let spartan = viewModel.spartan(forIndexPath: indexPath)

        let cell = tableView.dequeueReusableCellWithIdentifier("SpartanCell", forIndexPath: indexPath) as! SpartanCell
        cell.cellModel = SpartanCellModel(spartan: spartan, isComparing: viewModel.isComparing(spartan))
        cell.delegate = viewModel

        if spartan.isDefault {
            cell.accessoryType = .None
            cell.favoriteButton.hidden = true
        }

        let selectionView = UIView()
        selectionView.backgroundColor = UIColor(haloColor: .Cinder).lighter(0.3)
        cell.selectedBackgroundView = selectionView

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let spartan = viewModel.spartan(forIndexPath: indexPath)

        if let defaultGt = GamertagManager.sharedManager.gamertagForUser() where defaultGt == spartan.gamertag {
            UIApplication.appController().applicationViewController.haloTabBarController.selectedIndex = 0
            return
        }

        let statsVC = StoryboardScene.PlayerStats.playerStatsParentViewController()
        statsVC.viewModel = PlayerStatsParentViewModel(gamertag: spartan.gamertag)

        viewController.navigationController?.pushViewController(statsVC, animated: true)
        viewController.searchController.active = false
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = viewModel.sections.value[section]

        if section == .Filtered {
            return nil
        }

        let view = SectionHeaderView.loadFromNib()
        view.titleLabel.text = section.title

        return view
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = viewModel.sections.value[section]

        if section == .Filtered {
            return CGFloat.min
        }

        return 25
    }

    // MARK: - Private 

    private func setupAppearance() {
        loadingLabel.alpha = 0
        loadingLabel.font = UIFont.kelson(.Thin, size: 14)
        loadingLabel.textColor = UIColor(haloColor: .WhiteSmoke)
    }

    private func setupTableView() {
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor(haloColor: .Cinder)
        tableView.rowHeight = 60.0
    }

    private func setupBindAndFires() {
        viewModel.delegate = self

        viewModel.sections.bindAndFire { [weak self] (_) in
            self?.tableView.reloadData()
        }

        viewModel.defaultSpartan.bindAndFire { [weak self] (_) in
            self?.tableView.reloadData()
        }

        viewModel.favorites.bindAndFire { [weak self] (_) in
            self?.tableView.reloadData()
        }

        viewModel.spartans.bindAndFire { [weak self] (_) in
            self?.tableView.reloadData()
        }

        viewModel.filteredSpartans.bindAndFire { [weak self] (_) in
            self?.tableView.reloadData()
        }

        viewModel.isSearching.bindAndFire { [weak self] (_) in
            self?.tableView.reloadData()
        }

        viewModel.selectedSpartans.bindAndFire { [weak self] (spartans) in
            if spartans.count == 2 {
                let vc = StoryboardScene.PlayerComparison.comparisonTableViewController()
                vc.viewModel.spartans.value = spartans

                self?.navigationController?.pushViewController(vc, animated: true)
                self?.viewModel.selectedSpartans.value = []
            }
        }
    }
}

extension SpartansViewController: SpartansViewModelDelegate {
    func searchStarted() {
        tableView.tableHeaderView = loadingView
        loadingIndicator.show()
        UIView.animateWithDuration(0.3) { [weak self] in
            self?.loadingLabel.alpha = 1
        }
    }

    func searchEnded() {
        UIView.animateWithDuration(0.3, animations: { [weak self] in
            self?.loadingLabel.alpha = 0
            }) { [weak self] (_) in
                self?.loadingIndicator.hide()
                self?.tableView.tableHeaderView = nil
        }
    }
}
