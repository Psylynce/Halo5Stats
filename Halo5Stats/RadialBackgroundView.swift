//
//  RadialBackgroundView.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class RadialBackgroundView: UIView {

    var cloudColor: UIColor?
    let alphaColor = UIColor(white: 0, alpha: 0.25).cgColor
    let black = UIColor.black.cgColor

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let context = UIGraphicsGetCurrentContext()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let cloud = cloudColor?.cgColor ?? alphaColor
        let colors = [cloud, black]
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: [0, 1])
        let center = CGPoint(x: rect.width / 2, y: rect.height / 3)
        context?.drawRadialGradient(gradient!, startCenter: center, startRadius: 0, endCenter: center, endRadius: 225, options: .drawsAfterEndLocation)
    }
}
