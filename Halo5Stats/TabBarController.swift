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
    
    private func setupTabBarController() {
        let statsImage = UIImage(named: "SR")?.imageWithRenderingMode(.AlwaysTemplate)
        let statsNC = UINavigationController(rootViewController: playerStatsParentViewController)
        playerStatsParentViewController.addGamertagWatcher()
        statsNC.tabBarItem = UITabBarItem(title: "Stats", image: statsImage, selectedImage: nil)

        let historyImage = UIImage(named: "History")?.imageWithRenderingMode(.AlwaysTemplate)
        let gameHistoryNC = UINavigationController(rootViewController: gameHistoryViewController)
        gameHistoryViewController.addGamertagWatcher()
        gameHistoryNC.tabBarItem = UITabBarItem(title: "History", image: historyImage, selectedImage: nil)

        let compareImage = UIImage(named: "Compare")?.imageWithRenderingMode(.AlwaysTemplate)
        let comparisonNC = UINavigationController(rootViewController: playerComparisonViewController)
        playerComparisonViewController.addGamertagWatcher()
        comparisonNC.tabBarItem = UITabBarItem(title: "Compare", image: compareImage, selectedImage: nil)

        let settingsImage = UIImage(named: "Settings")?.imageWithRenderingMode(.AlwaysTemplate)
        let settingsNC = UINavigationController(rootViewController: settingsViewController)
        settingsNC.tabBarItem = UITabBarItem(title: "Settings", image: settingsImage, selectedImage: nil)
        
        setViewControllers([statsNC, gameHistoryNC, comparisonNC, settingsNC], animated: false)
    }
    
    private func styleTabBar() {
        UITabBar.appearance().barTintColor = UIColor(haloColor: .Black)
        UITabBar.appearance().tintColor = UIColor(haloColor: .WhiteSmoke)
        UITabBar.appearance().translucent = false
    }
    
    private func styleNavBar() {
        UINavigationBar.appearance().barTintColor = UIColor(haloColor: .Black)
        UINavigationBar.appearance().tintColor = UIColor(haloColor: .WhiteSmoke)
        let font = UIFont.kelson(.Regular, size: 18) ?? UIFont.systemFontOfSize(18)
        let titleAttributes: [String : AnyObject] = [NSForegroundColorAttributeName : UIColor.whiteColor(),
                               NSFontAttributeName : font]
        UINavigationBar.appearance().titleTextAttributes = titleAttributes
        UINavigationBar.appearance().translucent = false
    }
    
    // MARK: - UITabBarControllerDelegate
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        return true
    }

}

