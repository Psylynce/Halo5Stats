//
//  KDCell.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class KDCell: UITableViewCell {

    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet weak var kdTitleLabel: UILabel!
    @IBOutlet weak var kdaTitleLabel: UILabel!
    @IBOutlet var numberLabels: [UILabel]!
    @IBOutlet weak var kdLabel: UILabel!
    @IBOutlet weak var kdaLabel: UILabel!
    
    @IBOutlet var secondaryTitleLabels: [UILabel]!
    @IBOutlet weak var killsTitleLabel: UILabel!
    @IBOutlet weak var assistsTitleLabel: UILabel!
    @IBOutlet weak var deathsTitleLabel: UILabel!
    @IBOutlet var statLabels: [UILabel]!
    @IBOutlet weak var killsLabel: UILabel!
    @IBOutlet weak var assistsLabel: UILabel!
    @IBOutlet weak var deathsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        titleLabels.forEach {
            $0.font = UIFont.kelson(.Regular, size: 14)
        }
        kdTitleLabel.text = "KD"
        kdaTitleLabel.text = "KDA"

        numberLabels.forEach {
            $0.font = UIFont.kelson(.Bold, size: 42)
            $0.textColor = UIColor(haloColor: .WhiteSmoke)
        }

        secondaryTitleLabels.forEach {
            $0.font = UIFont.kelson(.Regular, size: 14)
        }
        killsTitleLabel.text = "Kills"
        assistsTitleLabel.text = "Assists"
        deathsTitleLabel.text = "Deaths"

        statLabels.forEach {
            $0.font = UIFont.kelson(.Regular, size: 18)
            $0.textColor = UIColor(haloColor: .WhiteSmoke)
        }

        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        selectionStyle = .none
    }

    func configure(_ stats: StatsModel, gameMode: GameMode, gamesCompleted: Int) {
        titleLabels.forEach {
            $0.textColor = gameMode.color
        }

        secondaryTitleLabels.forEach {
            $0.textColor = gameMode.color
        }

        kdLabel.text = "\(stats.killDeathRatio())"
        kdaLabel.text = "\(stats.kda(gamesCompleted))"

        killsLabel.text = "\(stats.kills)"
        assistsLabel.text = "\(stats.assists)"
        deathsLabel.text = "\(stats.deaths)"
    }
}
