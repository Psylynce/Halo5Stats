//
//  GameHistoryCell.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class GameHistoryCell: UITableViewCell {

    @IBOutlet weak var gameTypeImageView: UIImageView!
    @IBOutlet weak var gameTypeLabel: UILabel!
    @IBOutlet weak var mapNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var outcomeLabel: UILabel!
    @IBOutlet weak var containerView: UIView!

    @IBOutlet weak var mapImageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapImageViewTopConstraint: NSLayoutConstraint!

    var mapImageViewTopInitial: CGFloat!
    var mapImageViewBottomInitial: CGFloat!

    let placeholder = UIImage(named: "MapPlaceholder")

    func configure(match: MatchModel) {
        if let gameTypeImageUrl = match.gameTypeIconUrl {
            gameTypeImageView.tintedImage(forUrl: gameTypeImageUrl, color: UIColor.whiteColor())
        }

        mapImageView.image(forUrl: match.mapImageUrl)

        gameTypeLabel.text = match.gameType.uppercaseString
        gameTypeLabel.textColor = match.gameMode?.color()
        mapNameLabel.text = match.mapName
        dateLabel.text = DateFormatter.string(fromDate: match.date, format: .MonthDayYear)

        if let outcome = match.outcome {
            outcomeLabel.text = match.score
            outcomeLabel.textColor = outcome.color()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        clipsToBounds = true
        contentView.backgroundColor = UIColor.clearColor()
        backgroundColor = UIColor.clearColor()
        imageView?.backgroundColor = UIColor.clearColor()
        
        setupInitialPosition()
        let white = UIColor(haloColor: .WhiteSmoke)

        containerView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        outcomeLabel.font = UIFont.kelson(.Light, size: 14)

        gameTypeImageView.alpha = 0.3

        dateLabel.font = UIFont.kelson(.Light, size: 14)
        dateLabel.textColor = white

        gameTypeLabel.font = UIFont.kelson(.Regular, size: 14)
        gameTypeLabel.adjustsFontSizeToFitWidth = true
        gameTypeLabel.minimumScaleFactor = 0.8
        
        mapNameLabel.font = UIFont.kelson(.Light, size: 24)
        mapNameLabel.textColor = white
        selectionStyle = .None
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        mapImageView.image = placeholder
        gameTypeImageView.image = nil
    }
}

extension GameHistoryCell: ParallaxScrollingCell {

    var imageTopConstraint: NSLayoutConstraint {
        return mapImageViewTopConstraint
    }

    var imageBottomConstraint: NSLayoutConstraint {
        return mapImageViewBottomConstraint
    }

    var imageTopInitial: CGFloat {
        return mapImageViewTopInitial
    }

    var imageBottomInitial: CGFloat {
        return mapImageViewBottomInitial
    }

    func setupInitialPosition() {
        mapImageViewBottomConstraint.constant -= 2 * parallaxFactor
        mapImageViewTopInitial = mapImageViewTopConstraint.constant
        mapImageViewBottomInitial = mapImageViewBottomConstraint.constant
    }
}
