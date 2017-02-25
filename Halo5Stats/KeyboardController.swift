//
//  KeyboardController.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class KeyboardController: NSObject {

    @IBOutlet var scrollView: UIScrollView!

    fileprivate var originalContentInsets: UIEdgeInsets = UIEdgeInsets.zero
    fileprivate var originalScrollIndicatorInsets: UIEdgeInsets = UIEdgeInsets.zero
    fileprivate var keyboardUp: Bool = false

    fileprivate var window: UIWindow? {
        return UIApplication.shared.keyWindow
    }

    fileprivate var mainView: UIView? {
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

    fileprivate func registerKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    fileprivate func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    @objc fileprivate func keyboardWillShow(_ notification: Notification) {
        guard let scrollView = scrollView, let frameValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue, let window = window, let mainView = mainView, keyboardUp == false else { return }

        if originalContentInsets == UIEdgeInsets.zero || originalScrollIndicatorInsets == UIEdgeInsets.zero {
            originalContentInsets = scrollView.contentInset
            originalScrollIndicatorInsets = scrollView.scrollIndicatorInsets
        }

        let frame = mainView.convert(frameValue.cgRectValue, from: window)
        let scrollFrame = mainView.convert(scrollView.bounds, from: scrollView)
        let overlap = frame.intersection(scrollFrame).height

        var contentInsets = originalContentInsets
        contentInsets.bottom += overlap

        var scrollInsets = originalScrollIndicatorInsets
        scrollInsets.bottom += overlap

        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = scrollInsets

        keyboardUp = true
    }

    @objc fileprivate func keyboardWillHide(_ notification: Notification) {
        guard let scrollView = scrollView, keyboardUp else { return }

        scrollView.contentInset = originalContentInsets
        scrollView.scrollIndicatorInsets = originalScrollIndicatorInsets

        originalContentInsets = UIEdgeInsets.zero
        originalScrollIndicatorInsets = UIEdgeInsets.zero

        keyboardUp = false
    }
}
