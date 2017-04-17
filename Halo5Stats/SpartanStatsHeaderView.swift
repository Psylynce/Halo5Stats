//
//  SpartanStatsHeaderView.swift
//  Halo5Stats
//
//  Copyright © 2017 Justin Powell. All rights reserved.
//

import UIKit

protocol SpartanStatsHeaderViewDelegate: class {
    func didTapButton(for gameMode: GameMode?)
}

class SpartanStatsHeaderView: UIView {

    @IBOutlet var headerImageView: UIImageView!
    @IBOutlet var spartanImageView: CircleImageView!
    @IBOutlet var emblemImageView: UIImageView!
    @IBOutlet var gamertagLabel: UILabel!
    @IBOutlet var buttonContainer: UIView!
    @IBOutlet var arenaButton: UIButton!
    @IBOutlet var warzoneButton: UIButton!
    @IBOutlet var customGamesButton: UIButton!
    @IBOutlet var sliderView: UIView!
    @IBOutlet var sliderViewLeadingConstraint: NSLayoutConstraint!

    // MARK: - UIView

    override func awakeFromNib() {
        super.awakeFromNib()

        setupAppearance()
    }

    // MARK: - SpartanStatsHeaderView

    // MARK: Internal

    weak var delegate: SpartanStatsHeaderViewDelegate?
    var buttons: [UIButton] {
        return [arenaButton, warzoneButton, customGamesButton]
    }

    var effectView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: blur)
        effectView.alpha = 0

        return effectView
    }()

    func configure(with model: PlayerStatsParentViewModel, gameMode: GameMode?) {
        if let gamertag = model.gamertag {
            spartanImageView.spartanHeadImage(forGamertag: gamertag)
            emblemImageView.image(forUrl: ProfileService.emblemUrl(forGamertag: gamertag))
            gamertagLabel.text = model.spartan()?.displayGamertag ?? gamertag
        }

        if let mode = gameMode {
            spartanImageView.updateBorderColor(with: mode.color)
            headerImageView.image = mode.image
            sliderView.backgroundColor = mode.color
        }
    }

    func animate(with viewController: ServiceRecordViewController, currentIndex: Int) {
        let gameMode = viewController.viewModel.gameMode

        spartanImageView.updateBorderColor(with: gameMode.color)
        UIView.transition(with: headerImageView, duration: 0.3, options: .transitionCrossDissolve, animations: { [weak self] in
            self?.headerImageView.image = gameMode.image
            }, completion: nil)

        sliderViewLeadingConstraint.constant = CGFloat(currentIndex) * sliderView.bounds.width

        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.sliderView.backgroundColor = gameMode.color
            self.layoutIfNeeded()
        }, completion: nil)
    }

    // MARK: Private

    private func setupAppearance() {
        headerImageView.contentMode = .scaleAspectFill
        effectView.frame = bounds
        headerImageView.addSubview(effectView)

        gamertagLabel.text = ""
        gamertagLabel.textColor = .whiteSmoke
        gamertagLabel.font = UIFont.kelson(.Regular, size: 24)
        gamertagLabel.adjustsFontSizeToFitWidth = true
        gamertagLabel.minimumScaleFactor = 0.5

        buttons.forEach {
            $0.setTitleColor(.whiteSmoke, for: .normal)
            $0.titleLabel?.font = UIFont.kelson(.Regular, size: 18.0)
        }

        arenaButton.setTitle("Arena", for: .normal)
        warzoneButton.setTitle("Warzone", for: .normal)
        customGamesButton.setTitle("Custom", for: .normal)
    }

    // MARK: - Actions

    @IBAction func gameModeButtonTapped(_ sender: UIButton) {
        var gameMode: GameMode? = nil

        if sender == arenaButton {
            gameMode = .arena
        } else if sender == warzoneButton {
            gameMode = .warzone
        } else if sender == customGamesButton {
            gameMode = .custom
        }

        delegate?.didTapButton(for: gameMode)
    }
}

