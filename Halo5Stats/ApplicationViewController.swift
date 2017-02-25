//
//  ApplicationViewController.swift
//  Halo5Stats
//
//  Copyright © 2015 Justin Powell. All rights reserved.
//

import UIKit
import Foundation

class ApplicationViewController: UIViewController {
    
    @IBOutlet var containerView: UIView!

    var viewModel = ApplicationViewModel()

    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        launchViewController.delegate = self
        showAppropriateView()
        containerView.backgroundColor = UIColor(haloColor: .Black)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.updateMetadata()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - ApplicationViewController
    
    // MARK: - Internal
    
    lazy var haloTabBarController: TabBarController = TabBarController()
    lazy var launchViewController = StoryboardScene.SignIn.launchViewController()

    func defaultGamertagTapped() {
        launchViewController.isChangingGamertag = true
        swap(fromViewController: haloTabBarController, toViewController: launchViewController, toView: containerView)
    }

    // MARK: - Private
    
    fileprivate func showAppropriateView() {
        if GamertagManager.sharedManager.gamertagExists() {
            embed(viewController: haloTabBarController, inView: containerView)
        } else {
            embed(viewController: launchViewController, inView: containerView)
        }
    }
    
    fileprivate func launchWasSuccessful() {
        launchViewController.isChangingGamertag = false
        swap(fromViewController: launchViewController, toViewController: haloTabBarController, toView: containerView)
        haloTabBarController.selectedIndex = 0
    }
}

extension ApplicationViewController: LaunchViewControllerDelegate {

    func launchViewControllerButtonTapped(_ sender: UIButton) {
        launchWasSuccessful()
    }

    func cancelButtonTapped(_ sender: UIButton) {
        launchViewController.isChangingGamertag = false
        swap(fromViewController: launchViewController, toViewController: haloTabBarController, toView: containerView)
    }
}
