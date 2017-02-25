//
//  TitleCell.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class TitleCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        titleLabel.textColor = UIColor(haloColor: .WhiteSmoke)
        titleLabel.font = UIFont.kelson(.Medium, size: 18.0)
        titleLabel.textAlignment = .center

        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear

        selectionStyle = .none
    }

    func configure(_ text: String, gameMode: GameMode? = nil) {
        titleLabel.text = text

        if let mode = gameMode {
            titleLabel.textColor = mode.color
        }
    }
}
