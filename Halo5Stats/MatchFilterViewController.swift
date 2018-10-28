//
//  MatchFilterViewController.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class MatchFilterViewController: UIViewController {

    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var gradientBackgroundView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!

    @IBOutlet weak var arenaButton: UIButton!
    @IBOutlet weak var warzoneButton: UIButton!
    @IBOutlet weak var customsButton: UIButton!
    @IBOutlet var filterButtons: [UIButton]!

    @IBOutlet weak var arenaTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var arenaTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var warzoneTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var customsTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var customsLeadingConstraint: NSLayoutConstraint!

    let viewModel = MatchFilterViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindAndFires()
        setupAppearance()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewsToInitialValues()
        initialConstraintValues()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        animateOpen()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        gradientBackgroundView.verticalGradient(startColor: .curiousBlue, endColor: UIColor.clear)
    }

    @IBAction func closeButtonTapped(_ sender: UIButton) {
        close(applyFilters: false)
    }
    
    @IBAction func applyButtonTapped(_ sender: UIButton) {
        close(applyFilters: true)
    }

    @IBAction func arenaButtonTapped(_ sender: UIButton) {
        viewModel.arenaSelected.value = !viewModel.arenaSelected.value
    }

    @IBAction func warzoneButtonTapped(_ sender: UIButton) {
        viewModel.warzoneSelected.value = !viewModel.warzoneSelected.value
    }

    @IBAction func customsButtonTapped(_ sender: UIButton) {
        viewModel.customsSelected.value = !viewModel.customsSelected.value
    }
    
    // MARK: - Private

    fileprivate func setupBindAndFires() {
        viewModel.arenaSelected.bindAndFire { [weak self] (selected) in
            let color = selected ? UIColor.green : .whiteSmoke
            self?.arenaButton.setTitleColor(color, for: .normal)
        }

        viewModel.warzoneSelected.bindAndFire { [weak self] (selected) in
            let color = selected ? UIColor.green : .whiteSmoke
            self?.warzoneButton.setTitleColor(color, for: .normal)
        }

        viewModel.customsSelected.bindAndFire { [weak self] (selected) in
            let color = selected ? UIColor.green : .whiteSmoke
            self?.customsButton.setTitleColor(color, for: .normal)
        }
    }

    fileprivate func close(applyFilters apply: Bool) {
        closeAnimation() { [weak self] in
            if apply {
                self?.viewModel.applyFilters()
            }

            self?.dismiss(animated: false) {}
        }
    }

    fileprivate func setupAppearance() {
        view.backgroundColor = UIColor.clear

        closeButton.setTitle("Cancel", for: .normal)
        closeButton.setTitleColor(.whiteSmoke, for: .normal)

        applyButton.setTitle("Apply", for: .normal)
        applyButton.setTitleColor(.whiteSmoke, for: .normal)

        gradientBackgroundView.backgroundColor = UIColor.clear

        arenaButton.setTitle("ARENA", for: .normal)
        warzoneButton.setTitle("WARZONE", for: .normal)
        customsButton.setTitle("CUSTOMS", for: .normal)

        filterButtons.forEach {
            $0.setTitleColor(.whiteSmoke, for: .normal)
            $0.titleLabel?.font = UIFont.kelson(.Bold, size: 16)
        }
    }

    fileprivate func viewsToInitialValues() {
        gradientBackgroundView.alpha = 0
        closeButton.alpha = 0
        blurView.alpha = 0
    }

    fileprivate func viewsToFinalValues() {
        gradientBackgroundView.alpha = 1
        closeButton.alpha = 1
        blurView.alpha = 1
    }

    fileprivate func initialConstraintValues() {
        warzoneTopConstraint.constant = -50
        arenaTopConstraint.constant = -50
        arenaTrailingConstraint.constant = 0 - warzoneButton.frame.width
        customsTopConstraint.constant = -50
        customsLeadingConstraint.constant = 0 - warzoneButton.frame.width
    }

    fileprivate func finalConstraintValues() {
        warzoneTopConstraint.constant = 75
        arenaTopConstraint.constant = 75
        arenaTrailingConstraint.constant = 30
        customsTopConstraint.constant = 75
        customsLeadingConstraint.constant = 30
    }

    fileprivate func animateOpen() {
        finalConstraintValues()
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.viewsToFinalValues()
            self?.view.layoutIfNeeded()
        }) 
    }

    fileprivate func closeAnimation(_ completion: @escaping () -> Void) {
        initialConstraintValues()
        UIView.animate(withDuration: 0.3, animations: {
            [weak self] in
            self?.viewsToInitialValues()
            self?.view.layoutIfNeeded()
            }, completion: { (completed) in
                if completed {
                    completion()
                }
        }) 
    }
}
