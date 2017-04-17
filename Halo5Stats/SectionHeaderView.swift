//
//  SectionHeaderView.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class SectionHeaderView: UIView {

    @IBOutlet var titleLabel: UILabel!

    var startColor: UIColor = .midnight
    var endColor: UIColor = .elephant

    override func awakeFromNib() {
        super.awakeFromNib()

        titleLabel.font = UIFont.kelson(.Bold, size: 16)
        titleLabel.textColor = .whiteSmoke

        backgroundColor = UIColor.clear
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        verticalGradient(startColor: startColor, endColor: endColor)
    }
}
