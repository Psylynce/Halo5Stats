//
//  ServiceRecordViewController.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

protocol ServiceRecordScrollViewDelegate: class {
    func scrollViewDidScroll(_ scrollView: UIScrollView)
}

class ServiceRecordViewController: UITableViewController {

    @IBOutlet var refreshCustomView: UIView!
    @IBOutlet var loadingIndicator: LoadingIndicator!

    weak var delegate: ServiceRecordScrollViewDelegate?
    var viewModel: ServiceRecordViewModel! {
        didSet {
            viewModel.serviceRecord.bindAndFire { [weak self] (_) in
                self?.tableView.reloadData()
            }

            viewModel.sections.bindAndFire { [weak self] (_) in
                self?.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }

    // MAR: - Private

    fileprivate func setupTableView() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = .cinder

        tableView.register(UINib(nibName: "TitleCell", bundle: nil), forCellReuseIdentifier: "TitleCell")
        tableView.register(UINib(nibName: "WeaponCell", bundle: nil), forCellReuseIdentifier: "WeaponCell")
        tableView.register(UINib(nibName: "KDCell", bundle: nil), forCellReuseIdentifier: "KDCell")

        setupRefreshCustomView()
        refreshControl?.addTarget(self, action: #selector(refreshServiceRecord), for: .valueChanged)
    }

    fileprivate func setupRefreshCustomView() {
        guard let refreshControl = refreshControl else { return }
        refreshCustomView.frame = refreshControl.bounds
        refreshControl.addSubview(refreshCustomView)
        refreshCustomView.backgroundColor = UIColor.clear
        refreshControl.tintColor = UIColor.clear
    }

    @objc fileprivate func refreshServiceRecord() {
        loadingIndicator.show()
        viewModel.fetchServiceRecord(force: true) { [weak self] in
            self?.loadingIndicator.hide()
            self?.refreshControl?.endRefreshing()
        }
    }

    fileprivate func updateMedalCell() {
        for cell in tableView.visibleCells {
            if let cell = cell as? CollectionViewTableViewCell {
                cell.updateVisibleCells()
            }
        }
    }

    // MARK: UITableView Delegate and DataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.value.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let record = viewModel.record() else { return UITableViewCell() }
        let section = viewModel.sections.value[indexPath.section]

        switch section {
        case .topMedalsTitle, .mostUsedWeaponTitle:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as! TitleCell
            cell.configure(section.title.uppercased())

            return cell
        case .highestCSR:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CSRAndSRCell", for: indexPath) as! CSRAndSRCell
            if let csr = record.highestAttainedCSR, let spartanRank = record.spartanRank {
                cell.configure(csr, spartanRank: spartanRank)
            }

            return cell
        case .games:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GamesCell", for: indexPath) as! GamesCell
            cell.configure(record, gameMode: viewModel.gameMode)

            return cell
        case .kdAndKDA:
            let cell = tableView.dequeueReusableCell(withIdentifier: "KDCell", for: indexPath) as! KDCell
            cell.configure(record.stats, gameMode: viewModel.gameMode, gamesCompleted: record.totalGamesCompleted)

            return cell
        case .mostUsedWeapon:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeaponCell", for: indexPath) as! WeaponCell
            if let weapon = record.mostUsedWeapon {
                cell.configure(weapon, gameMode: viewModel.gameMode)
            }

            return cell
        case .topMedals, .stats:
            let identifier = section == .stats ? "VerticalCollectionViewTableViewCell" : "CollectionViewTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CollectionViewTableViewCell
            if let dataSource = section.dataSource(record) {
                cell.dataSource = dataSource
            }
            cell.collectionView.isUserInteractionEnabled = false

            return cell
        case .allMedals, .weapons:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectionCell", for: indexPath)
            cell.textLabel?.text = section.title

            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = viewModel.sections.value[indexPath.section]

        switch section {
        case .allMedals, .topMedals:
            guard let record = viewModel.record() else { return }
            let vc = StoryboardScene.PlayerStats.allMedalsViewController()
            vc.title = "\(viewModel.gameMode.title) Career Medals"
            vc.viewModel = AllMedalsViewModel(medals: record.medals)

            navigationController?.pushViewController(vc, animated: true)
        case .weapons:
            guard let record = viewModel.record() else { return }
            let vc = StoryboardScene.Weapons.weaponsViewController()
            vc.title = "\(viewModel.gameMode.title) Weapon Stats"
            vc.viewModel = WeaponsViewModel(weapons: record.weapons, gameMode: viewModel.gameMode)

            navigationController?.pushViewController(vc, animated: true)
        default:
            return
        }
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let section = viewModel.sections.value[indexPath.section]

        cell.backgroundColor = section.color

        if section == .allMedals || section == .weapons {
            let selectionView = UIView()
            selectionView.backgroundColor = section.color?.lighter()
            cell.selectedBackgroundView = selectionView
        }
    }

    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footer = view as! UITableViewHeaderFooterView
        footer.backgroundView?.backgroundColor = UIColor.clear
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let section = viewModel.sections.value[section]

        switch section {
        case .weapons:
            return 30
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = .cinder
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let record = viewModel.record() else { return 0 }
        let section = viewModel.sections.value[indexPath.section]

        switch section {
        case .highestCSR:
            return 146
        case .kdAndKDA, .games:
            return 150
        case .topMedals:
            return 100
        case .mostUsedWeapon:
            return 145
        case .stats:
            let num = CGFloat(record.stats.statDisplayItems().count / 3) + 1
            return 100 * num
        default:
            return 40
        }
    }

    // MARK: - ScrollView

    fileprivate var isScrolling: Bool = false

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll(scrollView)
    }

    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isScrolling = true
    }

    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            isScrolling = false
        }

        if !isScrolling && scrollView == tableView {
            updateMedalCell()
        }
    }

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isScrolling = false

        if !isScrolling && scrollView == tableView {
            updateMedalCell()
        }
    }
}
