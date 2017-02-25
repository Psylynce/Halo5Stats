//
//  UIView+Extensions.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

extension UIView {

    func removeGradientLayers() {
        if let sublayers = layer.sublayers {
            for layer in sublayers {
                if layer is CAGradientLayer {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }

    func gradient(startColor: UIColor, endColor: UIColor, startPoint: CGPoint, endPoint: CGPoint) {
        removeGradientLayers()

        let layer = CAGradientLayer()
        layer.frame = bounds
        layer.startPoint = startPoint
        layer.endPoint = endPoint
        layer.colors = [startColor.cgColor, endColor.cgColor]

        self.layer.insertSublayer(layer, at: 0)
    }

    func horizontalGradient(_ startColor: UIColor, endColor: UIColor) {
        gradient(startColor: startColor, endColor: endColor, startPoint: CGPoint(x: 0.0, y: 0.0), endPoint: CGPoint(x: 1.0, y: 0.0))
    }

    func verticalGradient(startColor: UIColor, endColor: UIColor) {
        gradient(startColor: startColor, endColor: endColor, startPoint: CGPoint(x: 0.0, y: 0.0), endPoint: CGPoint(x: 0.0, y: 1.0))
    }

    func darkGradient() {
        verticalGradient(startColor: UIColor(haloColor: .Black), endColor: UIColor(haloColor: .Nero))
    }

    func darkReverseGradient() {
        verticalGradient(startColor: UIColor(haloColor: .Nero), endColor: UIColor(haloColor: .Black))
    }
}
