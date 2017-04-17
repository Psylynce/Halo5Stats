//
//  LoadingIndicator.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class LoadingIndicator: UIView {

    var circleLayer: CAShapeLayer = CAShapeLayer()
    var circleRadius: CGFloat = 20
    var circleColor: UIColor = .whiteSmoke

    var animate: Bool = false {
        didSet {
            updateAnimations()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        setupAppearance()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let startAngle: CGFloat = .pi / 2.0
        let endAngle: CGFloat = startAngle + ( 2.0 * .pi)
        let path = UIBezierPath(arcCenter: center, radius: circleRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)

        circleLayer.position = center
        circleLayer.path = path.cgPath
    }

    // MARK: - Internal

    func show(animate: Bool = true) {
        isHidden = false
        self.animate = animate
    }

    func hide() {
        animate = false
        isHidden = true
    }

    // MARK: - Private

    fileprivate func setupAppearance() {
        isHidden = true
        circleLayer.frame = bounds
        circleLayer.lineWidth = 2
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = circleColor.cgColor
        layer.addSublayer(circleLayer)
        backgroundColor = UIColor.clear
    }

    fileprivate func updateAnimations() {
        if animate {
            circleLayer.add(strokeEndAnimation, forKey: "strokeEnd")
            circleLayer.add(strokeStartAnimation, forKey: "strokeStart")
            circleLayer.add(rotationAnimation, forKey: "transform.rotation")
        } else {
            circleLayer.removeAllAnimations()
        }
    }

    fileprivate let strokeEndAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 2
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)

        let group = CAAnimationGroup()
        group.duration = 2.5
        group.repeatCount = MAXFLOAT
        group.animations = [animation]

        return group
    }()

    fileprivate let strokeStartAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.beginTime = 0.5
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 2
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)

        let group = CAAnimationGroup()
        group.duration = 2.5
        group.repeatCount = MAXFLOAT
        group.animations = [animation]

        return group
    }()

    fileprivate let rotationAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = Double.pi * 2
        animation.duration = 4
        animation.repeatCount = MAXFLOAT

        return animation
    }()
}
