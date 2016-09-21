//
//  PlayerCarnageReportViewController.swift
//  Halo5Stats
//
//  Created by Justin Powell on 4/19/16.
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class PlayerCarnageReportViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var spartanImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!

    var viewModel: PlayerCarnageReportViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupAppearance()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        updateMedalCell()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.title = viewModel.player.gamertag

        if !SpartanManager.sharedManager.spartanIsSaved(viewModel.player.gamertag) {
            navigationItem.rightBarButtonItem = addSpartanButton
        } else {
            navigationItem.rightBarButtonItem = savedSpartanButton
        }
    }

    // MARK: - Private 

    private var addSpartanButton: UIBarButtonItem {
        let addSpartanImage = UIImage(named: "Add")
        let addButton = UIBarButtonItem(image: addSpartanImage, style: .Plain, target: self, action: #selector(addSpartanButtonTapped))
        return addButton
    }
    private var savedSpartanButton: UIBarButtonItem {
        let savedSpartanImage = UIImage(named: "Check")?.imageWithRenderingMode(.AlwaysTemplate)
        let savedButton = UIBarButtonItem(image: savedSpartanImage, style: .Plain, target: nil, action: nil)
        savedButton.tintColor = UIColor(haloColor: .SpringGreen)
        return savedButton
    }

    private func setupAppearance() {
        setupTableView()
        setupSpartanImageView()
        hideBackButtonTitle()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self

        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor(white: 0, alpha: 0.75)

        tableView.registerNib(UINib(nibName: "TitleCell", bundle: nil), forCellReuseIdentifier: "TitleCell")
        tableView.registerNib(UINib(nibName: "WeaponCell", bundle: nil), forCellReuseIdentifier: "WeaponCell")
        tableView.registerNib(UINib(nibName: "KDCell", bundle: nil), forCellReuseIdentifier: "KDCell")
    }

    private func setupSpartanImageView() {
        view.backgroundColor = UIColor(haloColor: .Black)
        spartanImageView.clipsToBounds = true
        spartanImageView.contentMode = .ScaleAspectFill
        let url = ProfileService.spartanImageUrl(forGamertag: viewModel.player.gamertag, size: "512")
        spartanImageView.image(forUrl: url)

        backgroundImageView.clipsToBounds = true
        backgroundImageView.contentMode = .ScaleAspectFill
        backgroundImageView.alpha = 0.5
        backgroundImageView.image = UIImage(named: "HA_BG")
    }

    @objc private func addSpartanButtonTapped() {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
        let barItem = UIBarButtonItem(customView: activityIndicator)
        navigationItem.rightBarButtonItem = barItem
        activityIndicator.startAnimating()
        viewModel.saveSpartan(viewModel.player) { [weak self] in
            activityIndicator.stopAnimating()
            self?.navigationItem.rightBarButtonItem = self?.savedSpartanButton
        }
    }

    private func updateMedalCell() {
        for cell in tableView.visibleCells {
            if let cell = cell as? CollectionViewTableViewCell {
                cell.updateVisibleCells()
            }
        }
    }
}

extension PlayerCarnageReportViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel.sections.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = viewModel.sections[indexPath.section]

        switch section {
        case .MedalsTitle, .MostUsedWeaponTitle, .WeaponsTitle, .StatsTitle, .KilledTitle, .KilledByTitle:
            let cell = tableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath: indexPath) as! TitleCell
            cell.configure(section.title().uppercaseString)

            return cell
        case .KDandKDA:
            let cell = tableView.dequeueReusableCellWithIdentifier("KDCell", forIndexPath: indexPath) as! KDCell
            if let gameMode = viewModel.match.gameMode {
                cell.configure(viewModel.player.stats, gameMode: gameMode, gamesCompleted: 1)
            }

            return cell
        case .Medals, .Stats:
            let identifier = section == .Stats ? "VerticalCollectionViewTableViewCell" : "CollectionViewTableViewCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! CollectionViewTableViewCell
            if let dataSource = section.dataSource(viewModel.player) {
                cell.dataSource = dataSource
            }

            return cell
        case .KilledOpponents, .KilledByOpponents:
            let cell = tableView.dequeueReusableCellWithIdentifier("OpponentCollectionViewTableViewCell", forIndexPath: indexPath) as! CollectionViewTableViewCell
            if let dataSource = section.dataSource(viewModel.player) {
                cell.dataSource = dataSource
            }

            return cell
        case .MostUsedWeapon:
            let cell = tableView.dequeueReusableCellWithIdentifier("WeaponCell", forIndexPath: indexPath) as! WeaponCell
            if let weapon = viewModel.player.mostUsedWeapon, gameMode = viewModel.match.gameMode {
                cell.configure(weapon, gameMode: gameMode)
            }

            return cell
        case .Weapons:
            let cell = tableView.dequeueReusableCellWithIdentifier("WeaponsCollectionViewCell", forIndexPath: indexPath) as! CollectionViewTableViewCell
            if let dataSource = section.dataSource(viewModel.player) {
                cell.dataSource = dataSource
            }

            return cell
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let section = viewModel.sections[indexPath.section]

        switch section {
        case .KDandKDA:
            return 150
        case .Medals:
            return 100
        case .MostUsedWeapon:
            return 145
        case .Weapons:
            return 140
        case .Stats:
            let num = CGFloat((viewModel.player.stats.statDisplayItems().count + 1 ) / 3)
            return 100 * num
        case .KilledOpponents, .KilledByOpponents:
            return 130
        default:
            return 40
        }
    }
}
