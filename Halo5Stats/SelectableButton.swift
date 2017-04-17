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

        layer.borderColor = isSelected ? selectedColor.cgColor : deselectedColor.cgColor
    }

    fileprivate let selectedColor = UIColor.whiteSmoke
    fileprivate let deselectedColor = UIColor.whiteSmoke.withAlphaComponent(0.4)

    fileprivate func setupAppearance() {
        titleLabel?.font = UIFont.kelson(.Regular, size: 12)
        setTitleColor(selectedColor, for: .selected)
        setTitleColor(deselectedColor, for: UIControlState())

        layer.borderWidth = 1
        layer.cornerRadius = 2
    }
}
