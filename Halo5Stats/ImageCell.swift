//
//  ImageCell.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var mapImageView: UIImageView!
    @IBOutlet var topSpaceConstraint: NSLayoutConstraint!
    @IBOutlet var bottomSpaceConstraint: NSLayoutConstraint!

    @IBOutlet var gameTypeImageView: UIImageView!
    @IBOutlet var mapNameLabel: UILabel!
    @IBOutlet var teamIconImageView: UIImageView!
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var durationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        winnerLabel.textColor = UIColor(haloColor: .WhiteSmoke)
        winnerLabel.font = UIFont.kelson(.Regular, size: 32)
        winnerLabel.adjustsFontSizeToFitWidth = true
        winnerLabel.minimumScaleFactor = 0.6

        mapNameLabel.textColor = UIColor(haloColor: .WhiteSmoke)
        mapNameLabel.font = UIFont.kelson(.Regular, size: 14)
        durationLabel.textColor = UIColor(haloColor: .WhiteSmoke)
        durationLabel.font = UIFont.kelson(.Regular, size: 14)

        durationLabel.text = ""
        mapNameLabel.text = ""
        mapNameLabel.adjustsFontSizeToFitWidth = true
        mapNameLabel.minimumScaleFactor = 0.7

        gameTypeImageView.contentMode = .scaleAspectFit

        clipsToBounds = false

        containerView.backgroundColor = UIColor.clear
        containerView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        selectionStyle = .none
    }

    func configure(_ match: MatchModel, player: MatchPlayerModel? = nil) {
        mapImageView.image(forUrl: match.mapImageUrl)
        mapNameLabel.text = match.mapName

        if let gameTypeIconUrl = match.gameTypeIconUrl {
            gameTypeImageView.tintedImage(forUrl: gameTypeIconUrl, color: UIColor(white: 1, alpha: 0.5))
        }

        if let iconUrl = match.teams[0].url, match.isTeamGame {
            teamIconImageView.image(forUrl: iconUrl)
        } else if let player = player {
            teamIconImageView.image(forUrl: player.emblemUrl)
        }

        if let duration = match.duration {
            durationLabel.text = duration
        }

        winnerLabel.text = match.score
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= 0 {
            containerView.clipsToBounds = true
            bottomSpaceConstraint.constant = -scrollView.contentOffset.y / 2
            topSpaceConstraint.constant = scrollView.contentOffset.y / 2
        } else {
            topSpaceConstraint.constant = scrollView.contentOffset.y
            containerView.clipsToBounds = false
        }
    }
}
