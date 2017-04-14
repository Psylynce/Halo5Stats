//
//  ScrollingHeaderProtocol.swift
//  Halo5Stats
//
//  Copyright © 2017 Justin Powell. All rights reserved.
//

import UIKit

protocol ScrollingHeaderView: class {
    func animateElements(scrollPercentage percentage: CGFloat, openAmount amount: CGFloat)
}

protocol ScrollingHeaderController: class {
    var scrollView: UIScrollView! { get }

    var scrollingHeaderView: ScrollingHeaderView! { get }
    var headerViewHeightConstraint: NSLayoutConstraint! { get }

    var maxHeaderHeight: CGFloat { get }
    var minHeaderHeight: CGFloat { get }

    var previousScrollOffset: CGFloat { get set }
}

extension ScrollingHeaderController where Self: UIViewController {

    var range: CGFloat {
        return maxHeaderHeight - minHeaderHeight
    }

    var midPoint: CGFloat {
        return minHeaderHeight + (range / 2.0)
    }

    var openAmount: CGFloat {
        return headerViewHeightConstraint.constant - minHeaderHeight
    }

    var percentage: CGFloat {
        return openAmount / range
    }

    func initializeHeader() {
        headerViewHeightConstraint.constant = maxHeaderHeight
        updateHeader()
    }

    func updateHeader() {
        scrollingHeaderView.animateElements(scrollPercentage: percentage, openAmount: openAmount)
    }

    func setScroll(position pos: CGFloat) {
        scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: pos)
    }

    func animateHeaderScroll(with scrollView: UIScrollView) {
        guard canAnimateHeader(with: scrollView) else { return }

        let absoluteTop: CGFloat = 0.0
        let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height

        let offset = scrollView.contentOffset.y

        let scrollDifference = offset - previousScrollOffset
        let isScrollingUp = scrollDifference < 0 && offset < absoluteBottom
        let isScrollingDown = scrollDifference > 0 && offset > absoluteTop

        var newHeight: CGFloat = headerViewHeightConstraint.constant

        if isScrollingUp && offset < 0 {
            newHeight = min(maxHeaderHeight, headerViewHeightConstraint.constant + abs(scrollDifference))
        } else if isScrollingDown {
            newHeight = max(minHeaderHeight, headerViewHeightConstraint.constant - abs(scrollDifference))
        }

        if newHeight != headerViewHeightConstraint.constant {
            headerViewHeightConstraint.constant = newHeight
            updateHeader()
            setScroll(position: previousScrollOffset)
        }

        previousScrollOffset = offset
    }

    func scrollViewDidStop() {
        if headerViewHeightConstraint.constant > midPoint {
            expandHeader()
        } else {
            collapseHeader()
        }
    }

    private func collapseHeader() {
        view.layoutIfNeeded()

        UIView.animate(withDuration: 0.2) {
            self.headerViewHeightConstraint.constant = self.minHeaderHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        }
    }

    private func expandHeader() {
        view.layoutIfNeeded()

        UIView.animate(withDuration: 0.2) {
            self.headerViewHeightConstraint.constant = self.maxHeaderHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        }
    }

    private func canAnimateHeader(with scrollView: UIScrollView) -> Bool {
        let maxHeight = scrollView.frame.height + headerViewHeightConstraint.constant - minHeaderHeight
        return scrollView.contentSize.height > maxHeight
    }
}