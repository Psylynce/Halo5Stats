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

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        updateAppearance()
        navigationController?.presentTransparentNavigationBar()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.hideTransparentNavigationBar()
    }

    // MARK: Private

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self

        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor(haloColor: .Cinder)
    }

    private func setupBindAndFires() {
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

    private func setupAppearance() {
        headerImageView.image = UIImage(named: "OceanBackground")

        versusLabel.font = UIFont.kelson(.ExtraBold, size: 24)
        versusLabel.textColor = UIColor(haloColor: .WhiteSmoke)

        playerOneGamertagLabel.font = UIFont.kelson(.Light, size: 16)
        playerOneGamertagLabel.textColor = UIColor(haloColor: .WhiteSmoke)
        playerOneGamertagLabel.adjustsFontSizeToFitWidth = true
        playerOneGamertagLabel.minimumScaleFactor = 0.7

        playerOneSpartanImageView.transform = CGAffineTransformMakeScale(-1, 1)
        playerOneSpartanImageView.contentMode = .ScaleAspectFill

        playerOneContainerView.layer.cornerRadius = 5
        playerOneContainerView.backgroundColor = UIColor(haloColor: .Black).colorWithAlphaComponent(0.6)

        playerTwoGamertagLabel.font = UIFont.kelson(.Light, size: 16)
        playerTwoGamertagLabel.textColor = UIColor(haloColor: .WhiteSmoke)
        playerTwoGamertagLabel.adjustsFontSizeToFitWidth = true
        playerTwoGamertagLabel.minimumScaleFactor = 0.7

        playerTwoSpartanImageView.contentMode = .ScaleAspectFill

        playerTwoContainerView.layer.cornerRadius = 5
        playerTwoContainerView.backgroundColor = UIColor(haloColor: .Black).colorWithAlphaComponent(0.6)

        hideBackButtonTitle()
    }

    private func updateAppearance() {
        guard let playerOne = viewModel.spartans.value.first, playerTwo = viewModel.spartans.value.last else { return }
        playerOneGamertagLabel.text = playerOne.displayGamertag
        playerOneEmblemImageView.image(forUrl: playerOne.emblemUrl)
        playerOneSpartanImageView.image(forUrl: playerOne.spartanImageUrl)

        playerTwoGamertagLabel.text = playerTwo.displayGamertag
        playerTwoEmblemImageView.image(forUrl: playerTwo.emblemUrl)
        playerTwoSpartanImageView.image(forUrl: playerTwo.spartanImageUrl)
    }
}

extension ComparisonTableViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel.sections.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let s = viewModel.sections[section]
        return viewModel.numberOfRows(forSection: s)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = viewModel.sections[indexPath.section]
        let compareItem = viewModel.compareItem(indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier("CompareCell", forIndexPath: indexPath) as! CompareCell

        cell.configure(comparableItem: compareItem, gameMode: section.gameMode)

        return cell
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = viewModel.sections[section]
        let view = SectionHeaderView.loadFromNib()
        view.titleLabel.text = section.title
        view.startColor = section.gameMode.color()
        view.endColor = section.gameMode.color().darker()
        
        return view
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
}
