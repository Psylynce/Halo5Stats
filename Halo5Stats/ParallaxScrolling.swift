//
//  ParallaxScrolling.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

protocol ParallaxScrollingCell {
    var imageTopConstraint: NSLayoutConstraint { get }
    var imageBottomConstraint: NSLayoutConstraint { get }

    var imageTopInitial: CGFloat { get }
    var imageBottomInitial: CGFloat { get }

    var parallaxFactor: CGFloat { get }

    func setupInitialPosition()
}

extension ParallaxScrollingCell {

    var parallaxFactor: CGFloat {
        return 20.0
    }

    func backgroundOffset(_ offset: CGFloat) {
        let boundOffset = max(0, min(1, offset))
        let pixelOffset = (1 - boundOffset) * 2 * parallaxFactor

        imageTopConstraint.constant = imageTopInitial - pixelOffset
        imageBottomConstraint.constant = imageBottomInitial + pixelOffset
    }
}

protocol ParallaxScrollingTableView {}

extension ParallaxScrollingTableView {

    func cellImageOffset(_ tableView: UITableView, cell: ParallaxScrollingCell, indexPath: IndexPath) {
        let cellFrame = tableView.rectForRow(at: indexPath)
        let cellFrameInTable = tableView.convert(cellFrame, to: tableView.superview)
        let cellOffset = cellFrameInTable.origin.y + cellFrameInTable.size.height
        let tableHeight = tableView.bounds.size.height + cellFrameInTable.size.height
        let cellOffsetFactor = cellOffset / tableHeight
        cell.backgroundOffset(cellOffsetFactor)
    }
}
