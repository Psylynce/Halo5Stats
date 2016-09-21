//
//  PlayerStatTitleCell.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class PlayerStatTitleCell: UITableViewCell {

    @IBOutlet weak var spartanLabel: UILabel!
    @IBOutlet weak var killsLabel: UILabel!
    @IBOutlet weak var assistsLabel: UILabel!
    @IBOutlet weak var deathsLabel: UILabel!
    @IBOutlet weak var headshotsLabel: UILabel!
    @IBOutlet var labels: [UILabel]!

    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.backgroundColor = UIColor.clearColor()
        backgroundColor = UIColor.clearColor()

        labels.forEach {
            $0.textColor = UIColor(haloColor: .WhiteSmoke)
            $0.font = UIFont.kelson(.Regular, size: 10.0)
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.6
            $0.textAlignment = .Center
        }

        spartanLabel.text = "Spartan"
        spartanLabel.textAlignment = .Left
        killsLabel.text = "Kills"
        assistsLabel.text = "Assists"
        deathsLabel.text = "Deaths"
        headshotsLabel.text = "Headshots"

        selectionStyle = .None
    }
}
