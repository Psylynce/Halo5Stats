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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.fetchSpartans()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.value.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = viewModel.sections.value[section]

        switch  section {
        case .favorites:
            return viewModel.favorites.value.count
        case .spartans:
            return viewModel.spartans.value.count
        case .filtered:
            return viewModel.filteredSpartans.value.count
        default:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let spartan = viewModel.spartan(forIndexPath: indexPath)

        let cell = tableView.dequeueReusableCell(withIdentifier: "SpartanCell", for: indexPath) as! SpartanCell
        cell.cellModel = SpartanCellModel(spartan: spartan, isComparing: viewModel.isComparing(spartan))
        cell.delegate = viewModel

        if spartan.isDefault {
            cell.accessoryType = .none
            cell.favoriteButton.isHidden = true
        }

        let selectionView = UIView()
        selectionView.backgroundColor = UIColor(haloColor: .Cinder).lighter(0.3)
        cell.selectedBackgroundView = selectionView

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let spartan = viewModel.spartan(forIndexPath: indexPath)

        if let defaultGt = GamertagManager.sharedManager.gamertagForUser(), defaultGt == spartan.gamertag {
            UIApplication.appController().applicationViewController.haloTabBarController.selectedIndex = 0
            return
        }

        let statsVC = StoryboardScene.PlayerStats.playerStatsParentViewController()
        statsVC.viewModel = PlayerStatsParentViewModel(gamertag: spartan.gamertag)

        viewController.navigationController?.pushViewController(statsVC, animated: true)
        viewController.searchController.isActive = false
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = viewModel.sections.value[section]

        if section == .filtered {
            return nil
        }

        let view = SectionHeaderView.loadFromNib()
        view.titleLabel.text = section.title

        return view
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = viewModel.sections.value[section]

        if section == .filtered {
            return CGFloat.leastNormalMagnitude
        }

        return 25
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return [deleteAction]
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let section = viewModel.sections.value[indexPath.section]

        switch section {
        case .default:
            return false
        default:
            return true
        }
    }

    // MARK: - Private 

    fileprivate func setupAppearance() {
        loadingLabel.alpha = 0
        loadingLabel.font = UIFont.kelson(.Thin, size: 14)
        loadingLabel.textColor = UIColor(haloColor: .WhiteSmoke)
    }

    fileprivate func setupTableView() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(haloColor: .Cinder)
        tableView.rowHeight = 60.0
    }

    fileprivate func setupBindAndFires() {
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

    fileprivate var deleteAction: UITableViewRowAction {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { [weak self] (action, indexPath) in
            guard let strongSelf = self else {
                self?.showDeletionError()
                return
            }

            let spartan = strongSelf.viewModel.spartan(forIndexPath: indexPath)
            Spartan.deleteSpartan(spartan.gamertag) { [weak self] (success) in
                if success {
                    self?.viewModel.fetchSpartans()
                } else {
                    self?.showDeletionError()
                }
            }
        }
        deleteAction.backgroundColor = UIColor.red

        return deleteAction
    }

    fileprivate func showDeletionError() {
        let operation = AlertOperation()
        operation.title = "Error Deleting Spartan"
        operation.message = "Sorry, that Spartan was not able to be deleted at this time. Please try again."

        UIApplication.appController().operationQueue.addOperation(operation)
    }
}

extension SpartansViewController: SpartansViewModelDelegate {
    func searchStarted() {
        tableView.tableHeaderView = loadingView
        loadingIndicator.show()
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.loadingLabel.alpha = 1
        }) 
    }

    func searchEnded() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.loadingLabel.alpha = 0
            }, completion: { [weak self] (_) in
                self?.loadingIndicator.hide()
                self?.tableView.tableHeaderView = nil
        }) 
    }
}
