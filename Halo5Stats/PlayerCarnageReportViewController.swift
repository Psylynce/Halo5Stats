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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        updateMedalCell()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.title = viewModel.player.gamertag

        if !SpartanManager.sharedManager.spartanIsSaved(viewModel.player.gamertag) {
            navigationItem.rightBarButtonItem = addSpartanButton
        } else {
            navigationItem.rightBarButtonItem = savedSpartanButton
        }
    }

    // MARK: - Private 

    fileprivate var addSpartanButton: UIBarButtonItem {
        let addSpartanImage = UIImage(named: "Add")
        let addButton = UIBarButtonItem(image: addSpartanImage, style: .plain, target: self, action: #selector(addSpartanButtonTapped))
        return addButton
    }
    fileprivate var savedSpartanButton: UIBarButtonItem {
        let savedSpartanImage = UIImage(named: "Check")?.withRenderingMode(.alwaysTemplate)
        let savedButton = UIBarButtonItem(image: savedSpartanImage, style: .plain, target: nil, action: nil)
        savedButton.tintColor = .springGreen
        return savedButton
    }

    fileprivate func setupAppearance() {
        setupTableView()
        setupSpartanImageView()
        hideBackButtonTitle()
    }

    fileprivate func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self

        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(white: 0, alpha: 0.75)

        tableView.register(UINib(nibName: "TitleCell", bundle: nil), forCellReuseIdentifier: "TitleCell")
        tableView.register(UINib(nibName: "WeaponCell", bundle: nil), forCellReuseIdentifier: "WeaponCell")
        tableView.register(UINib(nibName: "KDCell", bundle: nil), forCellReuseIdentifier: "KDCell")
    }

    fileprivate func setupSpartanImageView() {
        view.backgroundColor = .haloBlack
        spartanImageView.clipsToBounds = true
        spartanImageView.contentMode = .scaleAspectFill
        let url = ProfileService.spartanImageUrl(forGamertag: viewModel.player.gamertag, size: "512")
        spartanImageView.image(forUrl: url)

        backgroundImageView.clipsToBounds = true
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.alpha = 0.5
        backgroundImageView.image = UIImage(named: "HA_BG")
    }

    @objc fileprivate func addSpartanButtonTapped() {
        let activityIndicator = UIActivityIndicatorView(style: .white)
        let barItem = UIBarButtonItem(customView: activityIndicator)
        navigationItem.rightBarButtonItem = barItem
        activityIndicator.startAnimating()
        viewModel.saveSpartan(viewModel.player) { [weak self] in
            activityIndicator.stopAnimating()
            self?.navigationItem.rightBarButtonItem = self?.savedSpartanButton
        }
    }

    fileprivate func updateMedalCell() {
        for cell in tableView.visibleCells {
            if let cell = cell as? CollectionViewTableViewCell {
                cell.updateVisibleCells()
            }
        }
    }
}

extension PlayerCarnageReportViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel.sections[indexPath.section]

        switch section {
        case .medalsTitle, .mostUsedWeaponTitle, .weaponsTitle, .statsTitle, .killedTitle, .killedByTitle:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as! TitleCell
            cell.configure(section.title().uppercased())

            return cell
        case .kDandKDA:
            let cell = tableView.dequeueReusableCell(withIdentifier: "KDCell", for: indexPath) as! KDCell
            if let gameMode = viewModel.match.gameMode {
                cell.configure(viewModel.player.stats, gameMode: gameMode, gamesCompleted: 1)
            }

            return cell
        case .medals, .stats:
            let identifier = section == .stats ? "VerticalCollectionViewTableViewCell" : "CollectionViewTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CollectionViewTableViewCell
            if let dataSource = section.dataSource(viewModel.player) {
                cell.dataSource = dataSource
            }

            return cell
        case .killedOpponents, .killedByOpponents:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OpponentCollectionViewTableViewCell", for: indexPath) as! CollectionViewTableViewCell
            if let dataSource = section.dataSource(viewModel.player) {
                cell.dataSource = dataSource
            }

            return cell
        case .mostUsedWeapon:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeaponCell", for: indexPath) as! WeaponCell
            if let weapon = viewModel.player.mostUsedWeapon, let gameMode = viewModel.match.gameMode {
                cell.configure(weapon, gameMode: gameMode)
            }

            return cell
        case .weapons:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeaponsCollectionViewCell", for: indexPath) as! CollectionViewTableViewCell
            if let dataSource = section.dataSource(viewModel.player) {
                cell.dataSource = dataSource
            }

            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = viewModel.sections[indexPath.section]

        switch section {
        case .kDandKDA:
            return 150
        case .medals:
            return 100
        case .mostUsedWeapon:
            return 145
        case .weapons:
            return 140
        case .stats:
            let num = CGFloat((viewModel.player.stats.statDisplayItems().count + 1 ) / 3)
            return 100 * num
        case .killedOpponents, .killedByOpponents:
            return 130
        default:
            return 40
        }
    }
}
