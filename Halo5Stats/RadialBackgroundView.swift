//
//  RadialBackgroundView.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class RadialBackgroundView: UIView {

    var cloudColor: UIColor?
    let alphaColor = UIColor(white: 0, alpha: 0.25).CGColor
    let black = UIColor.blackColor().CGColor

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)

        let context = UIGraphicsGetCurrentContext()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let cloud = cloudColor?.CGColor ?? alphaColor
        let colors = [cloud, black]
        let gradient = CGGradientCreateWithColors(colorSpace, colors, [0, 1])
        let center = CGPoint(x: rect.width / 2, y: rect.height / 3)
        CGContextDrawRadialGradient(context, gradient, center, 0, center, 225, .DrawsAfterEndLocation)
    }
}
