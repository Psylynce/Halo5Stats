//
//  PlayerStatsCell.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class PlayerStatsCell: UITableViewCell {
    
    @IBOutlet weak var gamertagLabel: UILabel!
    @IBOutlet weak var killLabel: UILabel!
    @IBOutlet weak var assistLabel: UILabel!
    @IBOutlet weak var deathLabel: UILabel!
    @IBOutlet weak var headshotLabel: UILabel!
    @IBOutlet var statLabels: [UILabel]!

    @IBOutlet weak var killView: UIView!
    @IBOutlet weak var assistView: UIView!
    @IBOutlet weak var deathView: UIView!
    @IBOutlet weak var headshotView: UIView!
    @IBOutlet var statViews: [UIView]!

    override func awakeFromNib() {
        super.awakeFromNib()


        let textColor = UIColor(haloColor: .WhiteSmoke)
        gamertagLabel.textColor = textColor
        gamertagLabel.adjustsFontSizeToFitWidth = true
        gamertagLabel.minimumScaleFactor = 0.6
        statLabels.forEach {
            $0.textColor = textColor.darker(0.1)
            $0.font = UIFont.kelson(.Regular, size: 14.0)
        }

        statViews.forEach { $0.backgroundColor = UIColor.clear }

        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        selectionStyle = .none
    }

    func configure(_ player: MatchPlayerModel, isTeamGame: Bool) {
        let gamertag = player.didNotFinish ? "\(player.gamertag) DNF" : player.gamertag
        gamertagLabel.text = gamertag
        killLabel.text = "\(player.stats.kills)"
        assistLabel.text = "\(player.stats.assists)"
        deathLabel.text = "\(player.stats.deaths)"
        headshotLabel.text = "\(player.stats.headshots)"

        if let teamDetails = player.teamColor, let teamColor = teamDetails.color {
            let color = UIColor(hex: teamColor)
            let dark = color.darker()
            let darker = dark.darker()

            if isTeamGame {
                contentView.verticalGradient(startColor: darker, endColor: dark)
                killView.verticalGradient(startColor: darker, endColor: color)
                deathView.verticalGradient(startColor: darker, endColor: color)
            } else {
                contentView.darkGradient()
                killView.darkGradient()
                deathView.darkGradient()
            }
        }
    }
}
