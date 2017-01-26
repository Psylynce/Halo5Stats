//
//  TabBarController.swift
//  Halo5Stats
//
//  Copyright © 2015 Justin Powell. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
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
        statsNC.tabBarItem = UITabBarItem(title: "Stats", image: statsImage, selectedImage: nil)

        let historyImage = UIImage(named: "History")?.withRenderingMode(.alwaysTemplate)
        let gameHistoryNC = UINavigationController(rootViewController: gameHistoryViewController)
        gameHistoryViewController.addGamertagWatcher()
        gameHistoryNC.tabBarItem = UITabBarItem(title: "History", image: historyImage, selectedImage: nil)

        let compareImage = UIImage(named: "Compare")?.withRenderingMode(.alwaysTemplate)
        let comparisonNC = UINavigationController(rootViewController: playerComparisonViewController)
        playerComparisonViewController.addGamertagWatcher()
        comparisonNC.tabBarItem = UITabBarItem(title: "Compare", image: compareImage, selectedImage: nil)

        let settingsImage = UIImage(named: "Settings")?.withRenderingMode(.alwaysTemplate)
        let settingsNC = UINavigationController(rootViewController: settingsViewController)
        settingsNC.tabBarItem = UITabBarItem(title: "Settings", image: settingsImage, selectedImage: nil)
        
        setViewControllers([statsNC, gameHistoryNC, comparisonNC, settingsNC], animated: false)
    }
    
    fileprivate func styleTabBar() {
        UITabBar.appearance().barTintColor = UIColor(haloColor: .Black)
        UITabBar.appearance().tintColor = UIColor(haloColor: .WhiteSmoke)
        UITabBar.appearance().isTranslucent = false
    }
    
    fileprivate func styleNavBar() {
        UINavigationBar.appearance().barTintColor = UIColor(haloColor: .Black)
        UINavigationBar.appearance().tintColor = UIColor(haloColor: .WhiteSmoke)
        let font = UIFont.kelson(.Regular, size: 18) ?? UIFont.systemFont(ofSize: 18)
        let titleAttributes: [String : AnyObject] = [NSForegroundColorAttributeName : UIColor.white,
                               NSFontAttributeName : font]
        UINavigationBar.appearance().titleTextAttributes = titleAttributes
        UINavigationBar.appearance().isTranslucent = false
    }
    
    // MARK: - UITabBarControllerDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }

}

