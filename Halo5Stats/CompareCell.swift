//
//  CompareCell.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class CompareCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var playerOneValueLabel: UILabel!
    @IBOutlet weak var playerTwoValueLabel: UILabel!

    fileprivate let thin = UIFont.kelson(.Thin, size: 16)
    fileprivate let regular = UIFont.kelson(.Regular, size: 16)

    override func awakeFromNib() {
        super.awakeFromNib()

        nameLabel.font = UIFont.kelson(.Thin, size: 16)
        nameLabel.textColor = UIColor(haloColor: .CuriousBlue).lighter()
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.8

        playerOneValueLabel.textColor = UIColor(haloColor: .WhiteSmoke)
        playerOneValueLabel.adjustsFontSizeToFitWidth = true
        playerOneValueLabel.minimumScaleFactor = 0.7
        playerTwoValueLabel.textColor = UIColor(haloColor: .WhiteSmoke)
        playerTwoValueLabel.adjustsFontSizeToFitWidth = true
        playerTwoValueLabel.minimumScaleFactor = 0.7

        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        selectionStyle = .none
    }

    func configure(comparableItem item: StatCompareItem, gameMode: GameMode) {
        let valueOne = item.playerOneValue
        let valueTwo = item.playerTwoValue

        nameLabel.text = item.name
        nameLabel.textColor = gameMode == .Custom ? gameMode.color.lighter() : gameMode.color
        playerOneValueLabel.text = valueOne.cleanValue
        playerTwoValueLabel.text = valueTwo.cleanValue

        let itemName = item.name.lowercased()
        let reverseColors = itemName == "deaths" || itemName == "games lost" || itemName == "games tied"
        let valueOneHigher = valueOne > valueTwo

        if reverseColors {
            playerOneValueLabel.font = valueOneHigher ? thin : regular
            playerTwoValueLabel.font = valueOneHigher ? regular : thin
        } else {
            playerOneValueLabel.font = valueOneHigher ? regular : thin
            playerTwoValueLabel.font = valueOneHigher ? thin : regular
        }

        if valueOne == valueTwo {
            playerOneValueLabel.font = thin
            playerTwoValueLabel.font = thin
        }
    }
}
