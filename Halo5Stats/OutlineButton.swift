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

    fileprivate func setupAppearance() {
        backgroundColor = UIColor.clear
        layer.borderWidth = 1
        layer.borderColor = UIColor.whiteSmoke.cgColor
        layer.cornerRadius = 2
        titleLabel?.font = UIFont.kelson(.Regular, size: 18)
        setTitleColor(.whiteSmoke, for: UIControlState())
    }
}
