//
//  PlayerStatCell.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class PlayerStatCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

    @IBOutlet weak var leftBorder: UIView!
    @IBOutlet weak var centerBorder: UIView!
    @IBOutlet weak var rightBorder: UIView!

    @IBOutlet var borders: [UIView]!

    override func awakeFromNib() {
        super.awakeFromNib()

        borders.forEach {
            $0.backgroundColor = UIColor(haloColor: .CuriousBlue).darker(0.60)
        }

        titleLabel.textColor = UIColor(haloColor: .CuriousBlue).lighter()
        titleLabel.font = UIFont.kelson(.Light, size: 12.0)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.6

        valueLabel.textColor = UIColor(haloColor: .WhiteSmoke)
        valueLabel.font = UIFont.kelson(.Regular, size: 16.0)
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.minimumScaleFactor = 0.6

        contentView.backgroundColor = UIColor.clearColor()
        backgroundColor = UIColor.clearColor()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        borders.forEach { $0.hidden = false }
    }

    func configure(item: DisplayItem) {
        if let title = item.title {
            titleLabel.text = title
        }

        valueLabel.text = item.number
    }

    func hideBorder(forIndex index: Int) {
        let mod3 = index % 3
        if mod3 == 0 {
            leftBorder.hidden = true
        } else if mod3 == 2 {
            rightBorder.hidden = true
        }
    }

    func completelyHideBorder() {
        borders.forEach { $0.hidden = true }
    }
}
