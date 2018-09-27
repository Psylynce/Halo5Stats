//
//  PercentageCircleView.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

typealias PercentageDetail = (value: Int, color: UIColor)

class PercentageCircleView: UIView {

    var details: [PercentageDetail] = [] {
        didSet {
            drawLayers(details)
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        if let sublayers = layer.sublayers {
            sublayers.forEach { $0.removeFromSuperlayer() }
        }

        drawCircle()
        drawLayers(details)
    }

    fileprivate func drawCircle() {
        let arc = CAShapeLayer()
        arc.lineWidth = 10
        arc.path = UIBezierPath(ovalIn: CGRect(origin: bounds.origin, size: bounds.size)).cgPath
        arc.bounds = CGRect(origin: bounds.origin, size: bounds.size)
        arc.fillColor = UIColor.clear.cgColor
        arc.position = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
        layer.addSublayer(arc)
    }

    fileprivate func drawLayers(_ details: [PercentageDetail]) {
        if details.count == 2 {
            drawRatio(details)
        } else {
            drawTotal(details)
        }
    }

    fileprivate func drawRatio(_ details: [PercentageDetail]) {
        guard details.count == 2 else { return }
        let sorted = details.sorted { $0.value > $1.value }

        let larger = sorted[0]
        let smaller = sorted[1]

        let firstEndValue = CGFloat(smaller.value) / CGFloat(larger.value)

        drawPercentage(0, endValue: firstEndValue, strokeColor: smaller.color)
        drawPercentage(firstEndValue, endValue: 1, strokeColor: larger.color)
    }

    fileprivate func drawTotal(_ details: [PercentageDetail]) {
        let max = maxValue(details)
        var startValue: CGFloat = 0
        var endValue: CGFloat = 0
        var lastValue: CGFloat = 0

        for i in 0 ..< details.count {
            let detail = details[i]
            let value = CGFloat(detail.value)
            if detail != details[0] {
                startValue = endValue
            }
            if detail != details[details.count - 1] {
                endValue = value / max + lastValue
                lastValue = value / max
            } else {
                endValue = 1
            }

            drawPercentage(startValue, endValue: endValue, strokeColor: detail.color)
        }
    }

    fileprivate func maxValue(_ details: [PercentageDetail]) -> CGFloat {
        var max: CGFloat = 0

        for detail in details {
            max += CGFloat(detail.value)
        }

        return max
    }

    fileprivate func drawPercentage(_ startValue: CGFloat, endValue: CGFloat, strokeColor: UIColor) {
        let layer = CAShapeLayer()
        layer.lineWidth = 10
        layer.path = UIBezierPath(ovalIn: CGRect(origin: bounds.origin, size: bounds.size)).cgPath
        layer.bounds = CGRect(origin: bounds.origin, size: bounds.size)
        layer.strokeStart = startValue
        layer.strokeEnd = endValue
        layer.strokeColor = strokeColor.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.position = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
//        layer.addAnimation(clockWiseAnimation, forKey: "strokeEnd")

        let transform = CATransform3DRotate(layer.transform, -90.0 * CGFloat.pi / 180.0, 0.0, 0.0, 1.0)
        layer.transform = transform

        self.layer.addSublayer(layer)
    }

    fileprivate let clockWiseAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = 0.5
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        return animation
    }()
}
