//
//  GameHistoryHeaderView.swift
//  Halo5Stats
//
//  Copyright © 2017 Justin Powell. All rights reserved.
//

import UIKit

protocol GameHistoryHeaderViewDelegate: class {
    func gameModeButtonTapped()
}

class GameHistoryHeaderView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arenaButton: UIButton!
    @IBOutlet weak var warzoneButton: UIButton!
    @IBOutlet weak var customGamesButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabelTopConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupAppearance()
    }

    // MARK: - GameHistoryHeaderView

    // MARK: Internal

    weak var delegate: GameHistoryHeaderViewDelegate?
    var buttons: [UIButton] = []

    var selectedGameModes: [GameMode] {
        var modes: [GameMode] = []

        if arenaButton.isSelected {
            modes.append(.arena)
        }

        if warzoneButton.isSelected {
            modes.append(.warzone)
        }

        if customGamesButton.isSelected {
            modes.append(.custom)
        }

        return modes
    }

    var effectView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: blur)
        effectView.alpha = 0

        return effectView
    }()

    // MARK: Private

    private func setupAppearance() {
        backgroundColor = .cinder
        titleLabel.font = UIFont.kelson(.Bold, size: 18.0)
        titleLabel.textColor = .whiteSmoke

        buttons = [arenaButton, warzoneButton, customGamesButton]
        buttons.forEach {
            $0.tintColor = .whiteSmoke
            $0.isSelected = true
            let image = $0.imageView?.image?.withRenderingMode(.alwaysTemplate)
            $0.setImage(image, for: .normal)
            $0.imageView?.contentMode = .scaleAspectFit
            $0.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }

        backgroundImageView.image = #imageLiteral(resourceName: "gameHistoryBackground")
        effectView.frame = bounds
        backgroundImageView.addSubview(effectView)
    }

    @IBAction func gameModeButtonTapped(_ sender: UIButton) {
        if sender == arenaButton {
            arenaButton.isSelected = !arenaButton.isSelected
        } else if sender == warzoneButton {
            warzoneButton.isSelected = !warzoneButton.isSelected
        } else if sender == customGamesButton {
            customGamesButton.isSelected = !customGamesButton.isSelected
        }

        buttons.forEach {
            $0.tintColor = $0.isSelected ? .whiteSmoke : UIColor.whiteSmoke.withAlphaComponent(0.4)
        }

        delegate?.gameModeButtonTapped()
    }
}

extension GameHistoryHeaderView: ScrollingHeaderView {

    func animateElements(scrollPercentage percentage: CGFloat, openAmount amount: CGFloat) {
        titleLabel.alpha = percentage
        titleLabelTopConstraint.constant = (10 ... 35) • percentage
        effectView.alpha = 1.0 - percentage
    }
}

infix operator • : MultiplicationPrecedence
func • (left: ClosedRange<Int>, right: CGFloat) -> CGFloat {
    return CGFloat(left.upperBound - left.lowerBound) * right + CGFloat(left.lowerBound)
}
