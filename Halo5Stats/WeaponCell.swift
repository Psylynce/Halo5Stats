//
//  WeaponCell.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class WeaponCell: UITableViewCell {

    @IBOutlet weak var killsLabel: UILabel!
    @IBOutlet weak var headshotsLabel: UILabel!
    @IBOutlet weak var shotsFiredLabel: UILabel!
    @IBOutlet weak var shotsLandedLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var weaponImageView: UIImageView!
    @IBOutlet weak var percentageView: PercentageCircleView!

    @IBOutlet weak var killsTitleLabel: UILabel!
    @IBOutlet weak var headshotTitleLabel: UILabel!
    @IBOutlet weak var firedTitleLabel: UILabel!
    @IBOutlet weak var landedTitleLabel: UILabel!

    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet var labels: [UILabel]!

    override func awakeFromNib() {
        super.awakeFromNib()

        titleLabels.forEach {
            $0.textColor = UIColor(haloColor: .CuriousBlue).lighter()
            $0.font = UIFont.kelson(.Light, size: 12.0)
        }

        labels.forEach {
            $0.textColor = UIColor(haloColor: .WhiteSmoke)
            $0.font = UIFont.kelson(.Regular, size: 14.0)
        }

        killsTitleLabel.text = "Kills"
        headshotTitleLabel.text = "Headshots"
        firedTitleLabel.text = "Shots Fired"
        landedTitleLabel.text = "Shots Landed"

        weaponImageView.contentMode = .ScaleAspectFit
        percentageView.backgroundColor = UIColor.clearColor()

        contentView.backgroundColor = UIColor.clearColor()
        backgroundColor = UIColor.clearColor()
        selectionStyle = .None
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        weaponImageView.image = nil
        percentageView.details = []
    }

    func configure(weapon: WeaponModel, gameMode: GameMode) {
        killsLabel.text = "\(weapon.kills)"
        headshotsLabel.text = "\(weapon.headshots)"
        shotsFiredLabel.text = "\(weapon.shotsFired)"
        shotsLandedLabel.text = "\(weapon.shotsLanded)"
        percentageLabel.text = "\(weapon.percentage())%"

        weaponImageView.image(forUrl: weapon.largeIconUrl)
        percentageView.details = weapon.percentageDetails(gameMode)
        landedTitleLabel.textColor = gameMode.color()
    }
}
