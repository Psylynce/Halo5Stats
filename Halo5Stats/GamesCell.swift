//
//  GamesCell.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class GamesCell: UITableViewCell {

    @IBOutlet weak var percentageCircleView: PercentageCircleView!
    @IBOutlet weak var totalGamesTitleLabel: UILabel!
    @IBOutlet weak var gamesWonTitleLabel: UILabel!
    @IBOutlet weak var gamesLostTitleLabel: UILabel!
    @IBOutlet weak var gamesTiedTitleLabel: UILabel!
    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet weak var totalGamesLabel: UILabel!
    @IBOutlet weak var gamesWonLabel: UILabel!
    @IBOutlet weak var gamesLostLabel: UILabel!
    @IBOutlet weak var gamesTiedLabel: UILabel!
    @IBOutlet var valueLabels: [UILabel]!

    override func awakeFromNib() {
        super.awakeFromNib()

        percentageCircleView.backgroundColor = UIColor.clear

        titleLabels.forEach {
            $0.font = UIFont.kelson(.Regular, size: 14)
        }
        totalGamesTitleLabel.textColor = UIColor(haloColor: .WhiteSmoke)
        totalGamesTitleLabel.text = "Total Games"
        gamesWonTitleLabel.text = "Games Won"
        gamesLostTitleLabel.text = "Games Lost"
        gamesTiedTitleLabel.text = "Games Tied"

        gamesLostTitleLabel.textColor = UIColor(haloColor: .Bismark)
        gamesTiedTitleLabel.textColor = UIColor(haloColor: .SpringGreen)

        valueLabels.forEach {
            $0.font = UIFont.kelson(.Regular, size: 18)
            $0.textColor = UIColor(haloColor: .WhiteSmoke)
        }

        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        selectionStyle = .none
    }

    func configure(_ record: ServiceRecordModel, gameMode: GameMode) {
        percentageCircleView.details = record.percentageDetails(gameMode)

        totalGamesLabel.text = "\(record.totalGamesCompleted)"
        gamesWonLabel.text = "\(record.totalGamesWon)"
        gamesWonTitleLabel.textColor = gameMode.color
        gamesLostLabel.text = "\(record.totalGamesLost)"
        gamesTiedLabel.text = "\(record.totalGamesTied)"
    }
}
