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

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        viewsToInitialValues()
        initialConstraintValues()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        animateOpen()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        gradientBackgroundView.verticalGradient(startColor: UIColor(haloColor: .CuriousBlue), endColor: UIColor.clearColor())
    }

    @IBAction func closeButtonTapped(sender: UIButton) {
        close(applyFilters: false)
    }
    
    @IBAction func applyButtonTapped(sender: UIButton) {
        close(applyFilters: true)
    }

    @IBAction func arenaButtonTapped(sender: UIButton) {
        viewModel.arenaSelected.value = !viewModel.arenaSelected.value
    }

    @IBAction func warzoneButtonTapped(sender: UIButton) {
        viewModel.warzoneSelected.value = !viewModel.warzoneSelected.value
    }

    @IBAction func customsButtonTapped(sender: UIButton) {
        viewModel.customsSelected.value = !viewModel.customsSelected.value
    }
    
    // MARK: - Private

    private func setupBindAndFires() {
        viewModel.arenaSelected.bindAndFire { [weak self] (selected) in
            let color = selected ? UIColor.greenColor() : UIColor(haloColor: .WhiteSmoke)
            self?.arenaButton.setTitleColor(color, forState: .Normal)
        }

        viewModel.warzoneSelected.bindAndFire { [weak self] (selected) in
            let color = selected ? UIColor.greenColor() : UIColor(haloColor: .WhiteSmoke)
            self?.warzoneButton.setTitleColor(color, forState: .Normal)
        }

        viewModel.customsSelected.bindAndFire { [weak self] (selected) in
            let color = selected ? UIColor.greenColor() : UIColor(haloColor: .WhiteSmoke)
            self?.customsButton.setTitleColor(color, forState: .Normal)
        }
    }

    private func close(applyFilters apply: Bool) {
        closeAnimation() { [weak self] in
            if apply {
                self?.viewModel.applyFilters()
            }

            self?.dismissViewControllerAnimated(false) {}
        }
    }

    private func setupAppearance() {
        view.backgroundColor = UIColor.clearColor()

        closeButton.setTitle("Cancel", forState: .Normal)
        closeButton.setTitleColor(UIColor(haloColor: .WhiteSmoke), forState: .Normal)

        applyButton.setTitle("Apply", forState: .Normal)
        applyButton.setTitleColor(UIColor(haloColor: .WhiteSmoke), forState: .Normal)

        gradientBackgroundView.backgroundColor = UIColor.clearColor()

        arenaButton.setTitle("ARENA", forState: .Normal)
        warzoneButton.setTitle("WARZONE", forState: .Normal)
        customsButton.setTitle("CUSTOMS", forState: .Normal)

        filterButtons.forEach {
            $0.setTitleColor(UIColor(haloColor: .WhiteSmoke), forState: .Normal)
            $0.titleLabel?.font = UIFont.kelson(.Bold, size: 16)
        }
    }

    private func viewsToInitialValues() {
        gradientBackgroundView.alpha = 0
        closeButton.alpha = 0
        blurView.alpha = 0
    }

    private func viewsToFinalValues() {
        gradientBackgroundView.alpha = 1
        closeButton.alpha = 1
        blurView.alpha = 1
    }

    private func initialConstraintValues() {
        warzoneTopConstraint.constant = -50
        arenaTopConstraint.constant = -50
        arenaTrailingConstraint.constant = 0 - warzoneButton.frame.width
        customsTopConstraint.constant = -50
        customsLeadingConstraint.constant = 0 - warzoneButton.frame.width
    }

    private func finalConstraintValues() {
        warzoneTopConstraint.constant = 75
        arenaTopConstraint.constant = 75
        arenaTrailingConstraint.constant = 30
        customsTopConstraint.constant = 75
        customsLeadingConstraint.constant = 30
    }

    private func animateOpen() {
        finalConstraintValues()
        UIView.animateWithDuration(0.3) { [weak self] in
            self?.viewsToFinalValues()
            self?.view.layoutIfNeeded()
        }
    }

    private func closeAnimation(completion: Void -> Void) {
        initialConstraintValues()
        UIView.animateWithDuration(0.3, animations: {
            [weak self] in
            self?.viewsToInitialValues()
            self?.view.layoutIfNeeded()
            }) { (completed) in
                if completed {
                    completion()
                }
        }
    }
}
