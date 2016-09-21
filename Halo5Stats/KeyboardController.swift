//
//  KeyboardController.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class KeyboardController: NSObject {

    @IBOutlet var scrollView: UIScrollView!

    private var originalContentInsets: UIEdgeInsets = UIEdgeInsetsZero
    private var originalScrollIndicatorInsets: UIEdgeInsets = UIEdgeInsetsZero
    private var keyboardUp: Bool = false

    private var window: UIWindow? {
        return UIApplication.sharedApplication().keyWindow
    }

    private var mainView: UIView? {
        guard let window = window else { return nil }
        return window.rootViewController?.view
    }

    // MARK: - Initialization

    override init() {
        super.init()
        registerKeyboardObservers()
    }

    deinit {
        removeKeyboardObservers()
    }

    // MARK: - Observers

    private func registerKeyboardObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }

    private func removeKeyboardObservers() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let scrollView = scrollView, frameValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue, window = window, mainView = mainView where keyboardUp == false else { return }

        if originalContentInsets == UIEdgeInsetsZero || originalScrollIndicatorInsets == UIEdgeInsetsZero {
            originalContentInsets = scrollView.contentInset
            originalScrollIndicatorInsets = scrollView.scrollIndicatorInsets
        }

        let frame = mainView.convertRect(frameValue.CGRectValue(), fromView: window)
        let scrollFrame = mainView.convertRect(scrollView.bounds, fromView: scrollView)
        let overlap = frame.intersect(scrollFrame).height

        var contentInsets = originalContentInsets
        contentInsets.bottom += overlap

        var scrollInsets = originalScrollIndicatorInsets
        scrollInsets.bottom += overlap

        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = scrollInsets

        keyboardUp = true
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        guard let scrollView = scrollView where keyboardUp else { return }

        scrollView.contentInset = originalContentInsets
        scrollView.scrollIndicatorInsets = originalScrollIndicatorInsets

        originalContentInsets = UIEdgeInsetsZero
        originalScrollIndicatorInsets = UIEdgeInsetsZero

        keyboardUp = false
    }
}
