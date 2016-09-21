//
//  ServiceRecordViewController.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

protocol ServiceRecordScrollViewDelegate: class {
    func scrollViewDidScroll(scrollView: UIScrollView)
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

    private func setupTableView() {
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor(haloColor: .Cinder)

        tableView.registerNib(UINib(nibName: "TitleCell", bundle: nil), forCellReuseIdentifier: "TitleCell")
        tableView.registerNib(UINib(nibName: "WeaponCell", bundle: nil), forCellReuseIdentifier: "WeaponCell")
        tableView.registerNib(UINib(nibName: "KDCell", bundle: nil), forCellReuseIdentifier: "KDCell")

        setupRefreshCustomView()
        refreshControl?.addTarget(self, action: #selector(refreshServiceRecord), forControlEvents: .ValueChanged)
    }

    private func setupRefreshCustomView() {
        guard let refreshControl = refreshControl else { return }
        refreshCustomView.frame = refreshControl.bounds
        refreshControl.addSubview(refreshCustomView)
        refreshCustomView.backgroundColor = UIColor.clearColor()
        refreshControl.tintColor = UIColor.clearColor()
    }

    @objc private func refreshServiceRecord() {
        loadingIndicator.show()
        viewModel.fetchServiceRecord(force: true) { [weak self] in
            self?.loadingIndicator.hide()
            self?.refreshControl?.endRefreshing()
        }
    }

    private func updateMedalCell() {
        for cell in tableView.visibleCells {
            if let cell = cell as? CollectionViewTableViewCell {
                cell.updateVisibleCells()
            }
        }
    }

    // MARK: UITableView Delegate and DataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel.sections.value.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let record = viewModel.record() else { return UITableViewCell() }
        let section = viewModel.sections.value[indexPath.section]

        switch section {
        case .TopMedalsTitle, .MostUsedWeaponTitle:
            let cell = tableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath: indexPath) as! TitleCell
            cell.configure(section.title().uppercaseString)

            return cell
        case .HighestCSR:
            let cell = tableView.dequeueReusableCellWithIdentifier("CSRAndSRCell", forIndexPath: indexPath) as! CSRAndSRCell
            if let csr = record.highestAttainedCSR, spartanRank = record.spartanRank {
                cell.configure(csr, spartanRank: spartanRank)
            }

            return cell
        case .Games:
            let cell = tableView.dequeueReusableCellWithIdentifier("GamesCell", forIndexPath: indexPath) as! GamesCell
            cell.configure(record, gameMode: viewModel.gameMode)

            return cell
        case .KDAndKDA:
            let cell = tableView.dequeueReusableCellWithIdentifier("KDCell", forIndexPath: indexPath) as! KDCell
            cell.configure(record.stats, gameMode: viewModel.gameMode, gamesCompleted: record.totalGamesCompleted)

            return cell
        case .MostUsedWeapon:
            let cell = tableView.dequeueReusableCellWithIdentifier("WeaponCell", forIndexPath: indexPath) as! WeaponCell
            if let weapon = record.mostUsedWeapon {
                cell.configure(weapon, gameMode: viewModel.gameMode)
            }

            return cell
        case .TopMedals, .Stats:
            let identifier = section == .Stats ? "VerticalCollectionViewTableViewCell" : "CollectionViewTableViewCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! CollectionViewTableViewCell
            if let dataSource = section.dataSource(record) {
                cell.dataSource = dataSource
            }
            cell.collectionView.userInteractionEnabled = false

            return cell
        case .AllMedals:
            let cell = tableView.dequeueReusableCellWithIdentifier("SelectionCell", forIndexPath: indexPath)
            cell.textLabel?.text = section.title()

            return cell
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = viewModel.sections.value[indexPath.section]

        switch section {
        case .AllMedals, .TopMedals:
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            guard let record = viewModel.record() else { return }
            let vc = StoryboardScene.PlayerStats.allMedalsViewController()
            vc.title = "\(viewModel.gameMode.title()) Career Medals"
            vc.viewModel = AllMedalsViewModel(medals: record.medals)

            navigationController?.pushViewController(vc, animated: true)
        default:
            return
        }
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let section = viewModel.sections.value[indexPath.section]

        cell.backgroundColor = section.color

        if section == .AllMedals {
            let selectionView = UIView()
            selectionView.backgroundColor = UIColor(haloColor: .Elephant).lighter()
            cell.selectedBackgroundView = selectionView
        }
    }

    override func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footer = view as! UITableViewHeaderFooterView
        footer.backgroundView?.backgroundColor = UIColor.clearColor()
    }

    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let section = viewModel.sections.value[section]

        switch section {
        case .MostUsedWeapon:
            return 30
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor(haloColor: .Cinder)
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        guard let record = viewModel.record() else { return 0 }
        let section = viewModel.sections.value[indexPath.section]

        switch section {
        case .HighestCSR:
            return 146
        case .KDAndKDA, .Games:
            return 150
        case .TopMedals:
            return 100
        case .MostUsedWeapon:
            return 145
        case .Stats:
            let num = CGFloat(record.stats.statDisplayItems().count / 3) + 1
            return 100 * num
        default:
            return 40
        }
    }

    // MARK: - ScrollView

    private var isScrolling: Bool = false

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll(scrollView)
    }

    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        isScrolling = true
    }

    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            isScrolling = false
        }

        if !isScrolling && scrollView == tableView {
            updateMedalCell()
        }
    }

    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        isScrolling = false

        if !isScrolling && scrollView == tableView {
            updateMedalCell()
        }
    }
}
