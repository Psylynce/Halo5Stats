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
    let makeGreater = ConstraintMaker(relation: .greaterThanOrEqual, priority: .required, multiplier: 1.0)
    
    // MARK: - Parameters
    
    let relation: NSLayoutConstraint.Relation
    let priority: UILayoutPriority
    let multiplier: CGFloat
    
    // MARK: - Internal
    
    init(relation: NSLayoutConstraint.Relation, priority: UILayoutPriority, multiplier: CGFloat) {
        self.relation = relation
        self.priority = priority
        self.multiplier = multiplier
    }
    
    convenience override init() {
        self.init(relation: .equal, priority: .required, multiplier: 1.0)
    }
    
    // MARK: Generator
    
    func constraintFor(_ attribute: NSLayoutConstraint.Attribute, onView: UIView, toView: UIView? = nil, offset: CGFloat = 0.0) -> [NSLayoutConstraint] {
        onView.translatesAutoresizingMaskIntoConstraints = false
        
        var originView = onView
        var destinationView = toView ?? onView.superview!
        
        if [.bottom, .trailing, .right].contains(attribute) {
            originView = destinationView
            destinationView = onView
        }
        
        let constraint = NSLayoutConstraint(item: originView, attribute: attribute, relatedBy: relation, toItem: destinationView, attribute: attribute, multiplier: multiplier, constant: offset)
        constraint.priority = priority
        
        return [constraint]
    }
    
    // MARK: Pin Edge Constraints
    
    func pinEdgeConstraintsOnView(_ attributes: [NSLayoutConstraint.Attribute], onView view: UIView, toView: UIView? = nil, edgeInsets: UIEdgeInsets = UIEdgeInsets.zero) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        
        if attributes.contains(.leading) {
            constraints += constraintFor(.leading, onView: view, toView: toView, offset: edgeInsets.left)
        }
        
        if attributes.contains(.top) {
            constraints += constraintFor(.top, onView: view, toView: toView, offset: edgeInsets.top)
        }
        
        if attributes.contains(.trailing) {
            constraints += constraintFor(.trailing, onView: view, toView: toView, offset: edgeInsets.right)
        }
        
        if attributes.contains(.bottom) {
            constraints += constraintFor(.bottom, onView: view, toView: toView, offset: edgeInsets.bottom)
        }
        
        return constraints
    }
    
    // MARK: Pin to Fill Constraints
    
    func pinToFillSuperviewConstraintsOnView(_ view: UIView, edgeInsets: UIEdgeInsets) -> [NSLayoutConstraint] {
        let constraints = pinEdgeConstraintsOnView([.leading, .top, .trailing, .bottom], onView: view)
        
        return constraints
    }
    
    func pinView(_ view: UIView, toViewController viewController: UIViewController, edgeInsets: UIEdgeInsets = UIEdgeInsets.zero) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        
        constraints += pinEdgeConstraintsOnView([.leading, .trailing], onView: view, toView: viewController.view, edgeInsets: edgeInsets)
        constraints += pinTopLayoutGuideConstraintOnView(view, toViewController: viewController, offset: edgeInsets.top)
        constraints += pinBottomLayoutGuideConstraintOnView(view, toViewController: viewController, offset: edgeInsets.bottom)
        
        return constraints
    }
    
    // MARK: Pin Layout Guides
    
    func pinTopLayoutGuideConstraintOnView(_ view: UIView, toViewController: UIViewController, offset: CGFloat = 0.0) -> [NSLayoutConstraint] {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let topLayoutConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: relation, toItem: toViewController.topLayoutGuide, attribute: .bottom, multiplier: multiplier, constant: offset)
        topLayoutConstraint.priority = priority
        
        return [topLayoutConstraint]
    }
    
    func pinBottomLayoutGuideConstraintOnView(_ view: UIView, toViewController: UIViewController, offset: CGFloat = 0.0) -> [NSLayoutConstraint] {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomLayoutConstraint = NSLayoutConstraint(item: toViewController.bottomLayoutGuide, attribute: .top, relatedBy: relation, toItem: view, attribute: .bottom, multiplier: multiplier, constant: offset)
        bottomLayoutConstraint.priority = priority
        
        return [bottomLayoutConstraint]
    }
    
    // MARK: Centering
    
    func centerHorizontalConstraintOnView(_ view: UIView, toView: UIView? = nil, offset: CGFloat = 0.0) -> [NSLayoutConstraint] {
        let centerHorizontalConstraint = constraintFor(.centerX, onView: view, toView: toView, offset: offset)
        
        return centerHorizontalConstraint
    }
    
    func centerVerticalConstraintOnView(_ view: UIView, toView: UIView? = nil, offset: CGFloat = 0.0) -> [NSLayoutConstraint] {
        let centerVerticalConstraint = constraintFor(.centerY, onView: view, toView: toView, offset: offset)
        
        return centerVerticalConstraint
    }
    
    func centerContraintsOnView(_ view: UIView, toView: UIView? = nil, offset: CGFloat = 0.0) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        
        constraints += centerHorizontalConstraintOnView(view, toView: toView, offset: offset)
        constraints += centerVerticalConstraintOnView(view, toView: toView, offset: offset)
        
        return constraints
    }
    
    // MARK: Sizing
    
    func widthConstraintOnView(_ view: UIView, toView: UIView? = nil, offset: CGFloat = 0.0) -> [NSLayoutConstraint] {
        let widthConstraint = constraintFor(.width, onView: view, toView: toView, offset: offset)
        
        return widthConstraint
    }
    
    func heightConstraintOnView(_ view: UIView, toView: UIView? = nil, offset: CGFloat = 0.0) -> [NSLayoutConstraint] {
        let heightConstraint = constraintFor(.height, onView: view, toView: toView, offset: offset)
        
        return heightConstraint
    }
    
    func sizeConstraintOnView(_ view: UIView, toView: UIView? = nil, offset: CGFloat = 0.0) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        
        constraints += widthConstraintOnView(view, toView: toView, offset: offset)
        constraints += heightConstraintOnView(view, toView: toView, offset: offset)
        
        return constraints
    }
    
    // MARK: Fixed Sizing
    
    func fixedWidthConstraintOnView(_ view: UIView, withWidth width: CGFloat? = nil) -> [NSLayoutConstraint] {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let w = width ?? view.frame.width
        let widthConstraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: multiplier, constant: w)
        widthConstraint.priority = priority
        
        return [widthConstraint]
    }
    
    func fixedHeightConstraintOnView(_ view: UIView, withHeight height: CGFloat? = nil) -> [NSLayoutConstraint] {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let h = height ?? view.frame.height
        let heightConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: multiplier, constant: h)
        heightConstraint.priority = priority
        
        return [heightConstraint]
    }
    
    func fixedSizeConstraintOnView(_ view: UIView, withWidth width: CGFloat? = nil, withHeight height: CGFloat? = nil) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        
        constraints += fixedWidthConstraintOnView(view, withWidth: width)
        constraints += fixedHeightConstraintOnView(view, withHeight: height)
        
        return constraints
    }
}

