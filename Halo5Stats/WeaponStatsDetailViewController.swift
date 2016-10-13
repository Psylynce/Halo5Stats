//
//  WeaponStatsDetailViewController.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class WeaponStatsDetailViewController: UIViewController {

    @IBOutlet var weaponImageView: UIImageView!
    @IBOutlet var weaponNameLabel: UILabel!
    @IBOutlet var weaponDescriptionLabel: UILabel!
    @IBOutlet var killsHeaderLabel: UILabel!
    @IBOutlet var headshotsHeaderLabel: UILabel!
    @IBOutlet var killsLabel: UILabel!
    @IBOutlet var headshotsLabel: UILabel!
    @IBOutlet var percentageView: PercentageCircleView!
    @IBOutlet var accuracyLabel: UILabel!
    @IBOutlet var shotsFiredHeaderLabel: UILabel!
    @IBOutlet var shotsFiredLabel: UILabel!
    @IBOutlet var shotsLandedHeaderLabel: UILabel!
    @IBOutlet var shotsLandedLabel: UILabel!

    var viewModel: WeaponStatsDetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupAppearance()
        setupData()
    }

    private func setupAppearance() {
        view.backgroundColor = UIColor(haloColor: .Cinder)

        weaponNameLabel.font = UIFont.kelson(.Regular, size: 16)
        weaponNameLabel.textColor = UIColor(haloColor: .WhiteSmoke)

        weaponDescriptionLabel.font = UIFont.kelson(.Regular, size: 14)
        weaponDescriptionLabel.textColor = UIColor(haloColor: .WhiteSmoke)

        killsHeaderLabel.font = UIFont.kelson(.Light, size: 14)
        killsHeaderLabel.textColor = UIColor(haloColor: .CuriousBlue)

        headshotsHeaderLabel.font = UIFont.kelson(.Light, size: 14)
        headshotsHeaderLabel.textColor = UIColor(haloColor: .CuriousBlue)

        killsLabel.font = UIFont.kelson(.Regular, size: 14)
        killsLabel.textColor = UIColor(haloColor: .WhiteSmoke)

        headshotsLabel.font = UIFont.kelson(.Regular, size: 14)
        headshotsLabel.textColor = UIColor(haloColor: .WhiteSmoke)

        accuracyLabel.font = UIFont.kelson(.Light, size: 14)
        accuracyLabel.textColor = UIColor(haloColor: .WhiteSmoke)

        shotsFiredHeaderLabel.font = UIFont.kelson(.Light, size: 14)
        shotsFiredHeaderLabel.textColor = UIColor(haloColor: .CuriousBlue)

        shotsLandedHeaderLabel.font = UIFont.kelson(.Light, size: 14)
        shotsLandedHeaderLabel.textColor = UIColor(haloColor: .CuriousBlue)

        shotsFiredLabel.font = UIFont.kelson(.Regular, size: 14)
        shotsFiredLabel.textColor = UIColor(haloColor: .WhiteSmoke)

        shotsLandedLabel.font = UIFont.kelson(.Regular, size: 14)
        shotsLandedLabel.textColor = UIColor(haloColor: .WhiteSmoke)
    }

    private func setupData() {
        weaponNameLabel.text = viewModel.weapon.name
        weaponDescriptionLabel.text = viewModel.weapon.overview
        killsLabel.text = "\(viewModel.weapon.kills)"
        headshotsLabel.text = "\(viewModel.weapon.headshots)"
        accuracyLabel.text = "\(viewModel.weapon.accuracy)"
        shotsFiredLabel.text = "\(viewModel.weapon.shotsFired)"
        shotsLandedLabel.text = "\(viewModel.weapon.shotsLanded)"
        weaponImageView.image(forUrl: viewModel.weapon.largeIconUrl)
    }
}
