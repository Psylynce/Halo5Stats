//
//  UIViewController+Extensions.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func embed(viewController vc: UIViewController, inView view: UIView) {
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(vc)
        addSubview(vc.view, toView: view)
    }

    func swap(fromViewController oldViewController: UIViewController, toViewController newViewController: UIViewController, toView view: UIView, animated: Bool = true) {
        oldViewController.willMove(toParent: nil)
        addChild(newViewController)
        addSubview(newViewController.view, toView: view)
        newViewController.view.alpha = animated ? 0 : 1
        newViewController.view.layoutIfNeeded()

        if animated {
            UIView.animate(withDuration: 0.5, animations: {
                newViewController.view.alpha = 1
                oldViewController.view.alpha = 0
                }, completion: { [weak self] finished in
                    self?.finishSwap(oldViewController, newViewController: newViewController)
            })
        } else {
            finishSwap(oldViewController, newViewController: newViewController)
        }
    }

    func addSubview(_ subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)

        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
    }

    fileprivate func finishSwap(_ oldViewController: UIViewController, newViewController: UIViewController) {
        oldViewController.view.removeFromSuperview()
        oldViewController.removeFromParent()
        newViewController.didMove(toParent: self)
    }

    func hideBackButtonTitle() {
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }

    func showAlreadySavedAlert() {
        guard let queue = Container.resolve(OperationQueue.self) else { return }

        let alert = AlertOperation()
        alert.title = "That Spartan is already Saved"
        alert.message = "Please try another gamertag."

        queue.addOperation(alert)
    }
}
