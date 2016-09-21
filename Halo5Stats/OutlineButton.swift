//
//  OutlineButton.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class OutlineButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()

        setupAppearance()
    }

    private func setupAppearance() {
        backgroundColor = UIColor.clearColor()
        layer.borderWidth = 1
        layer.borderColor = UIColor(haloColor: .WhiteSmoke).CGColor
        layer.cornerRadius = 2
        titleLabel?.font = UIFont.kelson(.Regular, size: 18)
        setTitleColor(UIColor(haloColor: .WhiteSmoke), forState: .Normal)
    }
}
