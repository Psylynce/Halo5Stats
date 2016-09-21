//
//  ConstraintMaker.swift
//  Halo5Stats
//
//  Copyright © 2015 Justin Powell. All rights reserved.
//

import UIKit

class ConstraintMaker: NSObject {
    
    // MARK: - Static
    
    let make = ConstraintMaker()
    let makeGreater = ConstraintMaker(relation: .GreaterThanOrEqual, priority: UILayoutPriorityRequired, multiplier: 1.0)
    
    // MARK: - Parameters
    
    let relation: NSLayoutRelation
    let priority: UILayoutPriority
    let multiplier: CGFloat
    
    // MARK: - Internal
    
    init(relation: NSLayoutRelation, priority: UILayoutPriority, multiplier: CGFloat) {
        self.relation = relation
        self.priority = priority
        self.multiplier = multiplier
    }
    
    convenience override init() {
        self.init(relation: .Equal, priority: UILayoutPriorityRequired, multiplier: 1.0)
    }
    
    // MARK: Generator
    
    func constraintFor(attribute: NSLayoutAttribute, onView: UIView, toView: UIView? = nil, offset: CGFloat = 0.0) -> [NSLayoutConstraint] {
        onView.translatesAutoresizingMaskIntoConstraints = false
        
        var originView = onView
        var destinationView = toView ?? onView.superview!
        
        if [.Bottom, .Trailing, .Right].contains(attribute) {
            originView = destinationView
            destinationView = onView
        }
        
        let constraint = NSLayoutConstraint(item: originView, attribute: attribute, relatedBy: relation, toItem: destinationView, attribute: attribute, multiplier: multiplier, constant: offset)
        constraint.priority = priority
        
        return [constraint]
    }
    
    // MARK: Pin Edge Constraints
    
    func pinEdgeConstraintsOnView(attributes: [NSLayoutAttribute], onView view: UIView, toView: UIView? = nil, edgeInsets: UIEdgeInsets = UIEdgeInsetsZero) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        
        if attributes.contains(.Leading) {
            constraints += constraintFor(.Leading, onView: view, toView: toView, offset: edgeInsets.left)
        }
        
        if attributes.contains(.Top) {
            constraints += constraintFor(.Top, onView: view, toView: toView, offset: edgeInsets.top)
        }
        
        if attributes.contains(.Trailing) {
            constraints += constraintFor(.Trailing, onView: view, toView: toView, offset: edgeInsets.right)
        }
        
        if attributes.contains(.Bottom) {
            constraints += constraintFor(.Bottom, onView: view, toView: toView, offset: edgeInsets.bottom)
        }
        
        return constraints
    }
    
    // MARK: Pin to Fill Constraints
    
    func pinToFillSuperviewConstraintsOnView(view: UIView, edgeInsets: UIEdgeInsets) -> [NSLayoutConstraint] {
        let constraints = pinEdgeConstraintsOnView([.Leading, .Top, .Trailing, .Bottom], onView: view)
        
        return constraints
    }
    
    func pinView(view: UIView, toViewController viewController: UIViewController, edgeInsets: UIEdgeInsets = UIEdgeInsetsZero) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        
        constraints += pinEdgeConstraintsOnView([.Leading, .Trailing], onView: view, toView: viewController.view, edgeInsets: edgeInsets)
        constraints += pinTopLayoutGuideConstraintOnView(view, toViewController: viewController, offset: edgeInsets.top)
        constraints += pinBottomLayoutGuideConstraintOnView(view, toViewController: viewController, offset: edgeInsets.bottom)
        
        return constraints
    }
    
    // MARK: Pin Layout Guides
    
    func pinTopLayoutGuideConstraintOnView(view: UIView, toViewController: UIViewController, offset: CGFloat = 0.0) -> [NSLayoutConstraint] {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let topLayoutConstraint = NSLayoutConstraint(item: view, attribute: .Top, relatedBy: relation, toItem: toViewController.topLayoutGuide, attribute: .Bottom, multiplier: multiplier, constant: offset)
        topLayoutConstraint.priority = priority
        
        return [topLayoutConstraint]
    }
    
    func pinBottomLayoutGuideConstraintOnView(view: UIView, toViewController: UIViewController, offset: CGFloat = 0.0) -> [NSLayoutConstraint] {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomLayoutConstraint = NSLayoutConstraint(item: toViewController.bottomLayoutGuide, attribute: .Top, relatedBy: relation, toItem: view, attribute: .Bottom, multiplier: multiplier, constant: offset)
        bottomLayoutConstraint.priority = priority
        
        return [bottomLayoutConstraint]
    }
    
    // MARK: Centering
    
    func centerHorizontalConstraintOnView(view: UIView, toView: UIView? = nil, offset: CGFloat = 0.0) -> [NSLayoutConstraint] {
        let centerHorizontalConstraint = constraintFor(.CenterX, onView: view, toView: toView, offset: offset)
        
        return centerHorizontalConstraint
    }
    
    func centerVerticalConstraintOnView(view: UIView, toView: UIView? = nil, offset: CGFloat = 0.0) -> [NSLayoutConstraint] {
        let centerVerticalConstraint = constraintFor(.CenterY, onView: view, toView: toView, offset: offset)
        
        return centerVerticalConstraint
    }
    
    func centerContraintsOnView(view: UIView, toView: UIView? = nil, offset: CGFloat = 0.0) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        
        constraints += centerHorizontalConstraintOnView(view, toView: toView, offset: offset)
        constraints += centerVerticalConstraintOnView(view, toView: toView, offset: offset)
        
        return constraints
    }
    
    // MARK: Sizing
    
    func widthConstraintOnView(view: UIView, toView: UIView? = nil, offset: CGFloat = 0.0) -> [NSLayoutConstraint] {
        let widthConstraint = constraintFor(.Width, onView: view, toView: toView, offset: offset)
        
        return widthConstraint
    }
    
    func heightConstraintOnView(view: UIView, toView: UIView? = nil, offset: CGFloat = 0.0) -> [NSLayoutConstraint] {
        let heightConstraint = constraintFor(.Height, onView: view, toView: toView, offset: offset)
        
        return heightConstraint
    }
    
    func sizeConstraintOnView(view: UIView, toView: UIView? = nil, offset: CGFloat = 0.0) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        
        constraints += widthConstraintOnView(view, toView: toView, offset: offset)
        constraints += heightConstraintOnView(view, toView: toView, offset: offset)
        
        return constraints
    }
    
    // MARK: Fixed Sizing
    
    func fixedWidthConstraintOnView(view: UIView, withWidth width: CGFloat? = nil) -> [NSLayoutConstraint] {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let w = width ?? view.frame.width
        let widthConstraint = NSLayoutConstraint(item: view, attribute: .Width, relatedBy: relation, toItem: nil, attribute: .NotAnAttribute, multiplier: multiplier, constant: w)
        widthConstraint.priority = priority
        
        return [widthConstraint]
    }
    
    func fixedHeightConstraintOnView(view: UIView, withHeight height: CGFloat? = nil) -> [NSLayoutConstraint] {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let h = height ?? view.frame.height
        let heightConstraint = NSLayoutConstraint(item: view, attribute: .Height, relatedBy: relation, toItem: nil, attribute: .NotAnAttribute, multiplier: multiplier, constant: h)
        heightConstraint.priority = priority
        
        return [heightConstraint]
    }
    
    func fixedSizeConstraintOnView(view: UIView, withWidth width: CGFloat? = nil, withHeight height: CGFloat? = nil) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        
        constraints += fixedWidthConstraintOnView(view, withWidth: width)
        constraints += fixedHeightConstraintOnView(view, withHeight: height)
        
        return constraints
    }
}

