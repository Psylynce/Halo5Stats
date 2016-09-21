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
    var circleColor: UIColor = UIColor(haloColor: .WhiteSmoke)

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

        let center = CGPoint(x: CGRectGetMidX(bounds), y: CGRectGetMidY(bounds))
        let startAngle = CGFloat(-M_PI_2)
        let endAngle = startAngle + CGFloat(M_PI * 2)
        let path = UIBezierPath(arcCenter: center, radius: circleRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)

        circleLayer.position = center
        circleLayer.path = path.CGPath
    }

    // MARK: - Internal

    func show(animate animate: Bool = true) {
        hidden = false
        self.animate = animate
    }

    func hide() {
        animate = false
        hidden = true
    }

    // MARK: - Private

    private func setupAppearance() {
        hidden = true
        circleLayer.frame = bounds
        circleLayer.lineWidth = 2
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleLayer.strokeColor = circleColor.CGColor
        layer.addSublayer(circleLayer)
        backgroundColor = UIColor.clearColor()
    }

    private func updateAnimations() {
        if animate {
            circleLayer.addAnimation(strokeEndAnimation, forKey: "strokeEnd")
            circleLayer.addAnimation(strokeStartAnimation, forKey: "strokeStart")
            circleLayer.addAnimation(rotationAnimation, forKey: "transform.rotation")
        } else {
            circleLayer.removeAllAnimations()
        }
    }

    private let strokeEndAnimation: CAAnimation = {
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

    private let strokeStartAnimation: CAAnimation = {
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

    private let rotationAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = M_PI * 2
        animation.duration = 4
        animation.repeatCount = MAXFLOAT

        return animation
    }()
}
