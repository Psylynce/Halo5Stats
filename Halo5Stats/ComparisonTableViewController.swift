//
//  ComparisonTableViewController.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class ComparisonTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet var headerImageView: UIImageView!
    @IBOutlet var playerOneSpartanImageView: UIImageView!
    @IBOutlet var playerOneEmblemImageView: UIImageView!
    @IBOutlet var playerOneGamertagLabel: UILabel!
    @IBOutlet var playerOneContainerView: UIView!
    @IBOutlet var versusLabel: UILabel!
    @IBOutlet var playerTwoSpartanImageView: UIImageView!
    @IBOutlet var playerTwoEmblemImageView: UIImageView!
    @IBOutlet var playerTwoGamertagLabel: UILabel!
    @IBOutlet var playerTwoContainerView: UIView!

    var viewModel = CompareViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupBindAndFires()
        setupAppearance()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateAppearance()
        navigationController?.presentTransparentNavigationBar()
        AppReviewManager.shared.updateCount(for: .compareViewed)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.hideTransparentNavigationBar()
    }

    // MARK: Private

    fileprivate func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self

        tableView.separatorStyle = .none
        tableView.backgroundColor = .cinder
    }

    fileprivate func setupBindAndFires() {
        viewModel.spartans.bindAndFire { [weak self] (_) in
            self?.viewModel.setupComparableStats()
        }

        viewModel.arenaStats.bindAndFire { [weak self] (_) in
            self?.tableView?.reloadData()
        }

        viewModel.warzoneStats.bindAndFire { [weak self] (_) in
            self?.tableView?.reloadData()
        }

        viewModel.customStats.bindAndFire { [weak self] (_) in
            self?.tableView?.reloadData()
        }
    }

    fileprivate func setupAppearance() {
        headerImageView.image = UIImage(named: "OceanBackground")

        versusLabel.font = UIFont.kelson(.ExtraBold, size: 24)
        versusLabel.textColor = .whiteSmoke

        playerOneGamertagLabel.font = UIFont.kelson(.Light, size: 16)
        playerOneGamertagLabel.textColor = .whiteSmoke
        playerOneGamertagLabel.adjustsFontSizeToFitWidth = true
        playerOneGamertagLabel.minimumScaleFactor = 0.7

        playerOneSpartanImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
        playerOneSpartanImageView.contentMode = .scaleAspectFill

        playerOneContainerView.layer.cornerRadius = 5
        playerOneContainerView.backgroundColor = UIColor.haloBlack.withAlphaComponent(0.6)

        playerTwoGamertagLabel.font = UIFont.kelson(.Light, size: 16)
        playerTwoGamertagLabel.textColor = .whiteSmoke
        playerTwoGamertagLabel.adjustsFontSizeToFitWidth = true
        playerTwoGamertagLabel.minimumScaleFactor = 0.7

        playerTwoSpartanImageView.contentMode = .scaleAspectFill

        playerTwoContainerView.layer.cornerRadius = 5
        playerTwoContainerView.backgroundColor = UIColor.haloBlack.withAlphaComponent(0.6)

        hideBackButtonTitle()
    }

    fileprivate func updateAppearance() {
        guard let playerOne = viewModel.spartans.value.first, let playerTwo = viewModel.spartans.value.last else { return }
        playerOneGamertagLabel.text = playerOne.displayGamertag
        playerOneEmblemImageView.image(forUrl: playerOne.emblemUrl)
        playerOneSpartanImageView.image(forUrl: playerOne.spartanImageUrl)

        playerTwoGamertagLabel.text = playerTwo.displayGamertag
        playerTwoEmblemImageView.image(forUrl: playerTwo.emblemUrl)
        playerTwoSpartanImageView.image(forUrl: playerTwo.spartanImageUrl)
    }
}

extension ComparisonTableViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let s = viewModel.sections[section]
        return viewModel.numberOfRows(forSection: s)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel.sections[indexPath.section]
        let compareItem = viewModel.compareItem(indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompareCell", for: indexPath) as! CompareCell

        cell.configure(comparableItem: compareItem, gameMode: section.gameMode)

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = viewModel.sections[section]
        let view = SectionHeaderView.loadFromNib()
        view.titleLabel.text = section.title
        view.startColor = section.gameMode.color
        view.endColor = section.gameMode.color.darker()
        
        return view
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
}
