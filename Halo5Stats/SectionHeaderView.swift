//
//  SectionHeaderView.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class SectionHeaderView: UIView {

    @IBOutlet var titleLabel: UILabel!

    var startColor: UIColor = UIColor(haloColor: .Midnight)
    var endColor: UIColor = UIColor(haloColor: .Elephant)

    override func awakeFromNib() {
        super.awakeFromNib()

        titleLabel.font = UIFont.kelson(.Bold, size: 16)
        titleLabel.textColor = UIColor(haloColor: .WhiteSmoke)

        backgroundColor = UIColor.clearColor()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        verticalGradient(startColor: startColor, endColor: endColor)
    }
}
