//
//  SelectableButton.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class SelectableButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()

        setupAppearance()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.borderColor = selected ? selectedColor.CGColor : deselectedColor.CGColor
    }

    private let selectedColor = UIColor(haloColor: .WhiteSmoke)
    private let deselectedColor = UIColor(haloColor: .WhiteSmoke).colorWithAlphaComponent(0.4)

    private func setupAppearance() {
        titleLabel?.font = UIFont.kelson(.Regular, size: 12)
        setTitleColor(selectedColor, forState: .Selected)
        setTitleColor(deselectedColor, forState: .Normal)

        layer.borderWidth = 1
        layer.cornerRadius = 2
    }
}
