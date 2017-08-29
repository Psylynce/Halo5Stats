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

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var arenaButton: UIButton!
    @IBOutlet var warzoneButton: UIButton!
    @IBOutlet var customGamesButton: UIButton!

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

    // MARK: Private

    private func setupAppearance() {
        backgroundColor = .cinder
        titleLabel.font = UIFont.kelson(.Regular, size: 18.0)
        titleLabel.textColor = .whiteSmoke

        let deselectedColor = UIColor.whiteSmoke.withAlphaComponent(0.6)
        buttons = [arenaButton, warzoneButton, customGamesButton]
        buttons.forEach {
            $0.tintColor = .clear
            $0.setTitleColor(.whiteSmoke, for: .selected)
            $0.setTitleColor(deselectedColor, for: .normal)
            $0.isSelected = true
        }
    }

    @IBAction func gameModeButtonTapped(_ sender: UIButton) {
        if sender == arenaButton {
            arenaButton.isSelected = !arenaButton.isSelected
        } else if sender == warzoneButton {
            warzoneButton.isSelected = !warzoneButton.isSelected
        } else if sender == customGamesButton {
            customGamesButton.isSelected = !customGamesButton.isSelected
        }

        delegate?.gameModeButtonTapped()
    }
}

extension GameHistoryHeaderView: ScrollingHeaderView {

    func animateElements(scrollPercentage percentage: CGFloat, openAmount amount: CGFloat) {
        titleLabel.alpha = percentage
    }
}
