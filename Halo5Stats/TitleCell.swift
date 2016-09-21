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
        titleLabel.textAlignment = .Center

        contentView.backgroundColor = UIColor.clearColor()
        backgroundColor = UIColor.clearColor()

        selectionStyle = .None
    }

    func configure(text: String, gameMode: GameMode? = nil) {
        titleLabel.text = text

        if let mode = gameMode {
            titleLabel.textColor = mode.color()
        }
    }
}
