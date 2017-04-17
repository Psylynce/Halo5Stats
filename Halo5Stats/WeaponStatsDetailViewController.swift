//
//  WeaponStatsDetailViewController.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class WeaponStatsDetailViewController: UIViewController {

    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var weaponImageView: UIImageView!
    @IBOutlet var weaponNameLabel: UILabel!
    @IBOutlet var weaponNameUnderlineView: UIView!
    @IBOutlet var weaponDescriptionLabel: UILabel!
    @IBOutlet var killsLabel: UILabel!
    @IBOutlet var headshotsLabel: UILabel!
    @IBOutlet var accuracyLabel: UILabel!
    @IBOutlet var shotsFiredLabel: UILabel!
    @IBOutlet var shotsLandedLabel: UILabel!
    @IBOutlet var subHeaderLabels: [UILabel]!
    @IBOutlet var subHeaderUnderlineViews: [UIView]!

    var viewModel: WeaponStatsDetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupAppearance()
        setupData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.presentTransparentNavigationBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.hideTransparentNavigationBar()
    }

    fileprivate func setupAppearance() {
        view.verticalGradient(startColor: viewModel.weapon.type.color.darker(), endColor: .cinder)
        backgroundImageView.image = viewModel.weapon.type.image

        weaponNameLabel.font = UIFont.kelson(.Regular, size: 24)
        weaponNameLabel.textColor = .whiteSmoke

        weaponNameUnderlineView.backgroundColor = .whiteSmoke

        weaponDescriptionLabel.font = UIFont.kelson(.Light, size: 14)
        weaponDescriptionLabel.textColor = .whiteSmoke

        killsLabel.font = UIFont.kelson(.Bold, size: 18)
        killsLabel.textColor = .whiteSmoke

        headshotsLabel.font = UIFont.kelson(.Regular, size: 14)
        headshotsLabel.textColor = .whiteSmoke

        accuracyLabel.font = UIFont.kelson(.Bold, size: 18)
        accuracyLabel.textColor = .whiteSmoke

        shotsFiredLabel.font = UIFont.kelson(.Regular, size: 14)
        shotsFiredLabel.textColor = .whiteSmoke

        shotsLandedLabel.font = UIFont.kelson(.Regular, size: 14)
        shotsLandedLabel.textColor = .whiteSmoke

        subHeaderLabels.forEach {
            $0.font = UIFont.kelson(.Light, size: 14)
            $0.textColor = .whiteSmoke
            $0.text = $0.text?.uppercased()
        }

        subHeaderUnderlineViews.forEach {
            $0.backgroundColor = .curiousBlue
        }

        hideBackButtonTitle()
    }

    fileprivate func setupData() {
        weaponNameLabel.text = viewModel.weapon.name
        weaponDescriptionLabel.text = viewModel.weapon.overview
        killsLabel.text = "\(viewModel.weapon.kills)"
        headshotsLabel.text = "\(viewModel.weapon.headshots)"
        accuracyLabel.text = "\(viewModel.weapon.accuracy)%"
        shotsFiredLabel.text = "\(viewModel.weapon.shotsFired)"
        shotsLandedLabel.text = "\(viewModel.weapon.shotsLanded)"
        weaponImageView.image = viewModel.imageManager.cachedImage(viewModel.weapon)
    }
}
