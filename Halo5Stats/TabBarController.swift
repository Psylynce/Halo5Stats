//
//  TabBarController.swift
//  Halo5Stats
//
//  Copyright © 2015 Justin Powell. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    private struct Layout {
        static let imageInsets = UIEdgeInsets(top: 5.5, left: 0, bottom: -5.5, right: 0)
    }
    
    // MARK: - UIViewContoller

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        setupTabBarController()
        styleTabBar()
        styleNavBar()
    }
    
    // MARK: - TabBarController
    
    // MARK: Internal
    
    lazy var playerStatsParentViewController = StoryboardScene.PlayerStats.playerStatsParentViewController()
    lazy var gameHistoryViewController = StoryboardScene.GameHistory.gameHistoryViewController()
    lazy var playerComparisonViewController = StoryboardScene.PlayerComparison.playerComparisonViewController()
    lazy var settingsViewController = StoryboardScene.Settings.settingsViewController()

    // MARK: Private
    
    fileprivate func setupTabBarController() {
        let statsImage = UIImage(named: "SR")?.withRenderingMode(.alwaysTemplate)
        let statsNC = UINavigationController(rootViewController: playerStatsParentViewController)
        playerStatsParentViewController.addGamertagWatcher()
        statsNC.tabBarItem = UITabBarItem(title: nil, image: statsImage, selectedImage: nil)

        let historyImage = UIImage(named: "History")?.withRenderingMode(.alwaysTemplate)
        let gameHistoryNC = UINavigationController(rootViewController: gameHistoryViewController)
        gameHistoryViewController.addGamertagWatcher()
        gameHistoryNC.tabBarItem = UITabBarItem(title: nil, image: historyImage, selectedImage: nil)

        let compareImage = UIImage(named: "Compare")?.withRenderingMode(.alwaysTemplate)
        let comparisonNC = UINavigationController(rootViewController: playerComparisonViewController)
        playerComparisonViewController.addGamertagWatcher()
        comparisonNC.tabBarItem = UITabBarItem(title: nil, image: compareImage, selectedImage: nil)

        let settingsImage = UIImage(named: "Settings")?.withRenderingMode(.alwaysTemplate)
        let settingsNC = UINavigationController(rootViewController: settingsViewController)
        settingsNC.tabBarItem = UITabBarItem(title: nil, image: settingsImage, selectedImage: nil)

        let controllers = [statsNC, gameHistoryNC, comparisonNC, settingsNC]

        controllers.forEach { $0.tabBarItem.imageInsets = Layout.imageInsets }
        
        setViewControllers(controllers, animated: false)
    }
    
    fileprivate func styleTabBar() {
        UITabBar.appearance().barTintColor = .haloBlack
        UITabBar.appearance().tintColor = .whiteSmoke
        UITabBar.appearance().isTranslucent = false
    }
    
    fileprivate func styleNavBar() {
        UINavigationBar.appearance().barTintColor = .haloBlack
        UINavigationBar.appearance().tintColor = .whiteSmoke
        let font = UIFont.kelson(.Regular, size: 18) ?? UIFont.systemFont(ofSize: 18)
        let titleAttributes: [NSAttributedString.Key : AnyObject] = [
            .foregroundColor : UIColor.white,
            .font : font
        ]
        UINavigationBar.appearance().titleTextAttributes = titleAttributes
        UINavigationBar.appearance().isTranslucent = false
    }
    
    // MARK: - UITabBarControllerDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }

}
