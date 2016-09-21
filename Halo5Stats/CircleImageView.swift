//
//  CircleImageView.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {

    var borderWidth: CGFloat = 2
    var borderColor = UIColor(haloColor: .CuriousBlue)
    var bgColor = UIColor(haloColor: .Cinder)

    override func awakeFromNib() {
        super.awakeFromNib()

        setupAppearance()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = 0.5 * bounds.width
    }

    private func setupAppearance() {
        contentMode = .ScaleAspectFit
        clipsToBounds = true
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.CGColor
        layer.transform = CATransform3DMakeScale(1, 1, 0)
        backgroundColor = bgColor
    }

    func updateBorderColor(with color: UIColor) {
        UIView.animateWithDuration(0.2) { [weak self] in
            self?.layer.borderColor = color.CGColor
        }
    }
}
