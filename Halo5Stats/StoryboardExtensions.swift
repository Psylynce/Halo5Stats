//
//  StoryboardExtensions.swift
//  Halo5Stats
//
//  Copyright © 2015 Justin Powell. All rights reserved.
//

// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import UIKit
import Foundation

protocol StoryboardSceneType {
    static var storyboardName: String { get }
}

extension StoryboardSceneType {
    static func storyboard() -> UIStoryboard {
        return UIStoryboard(name: self.storyboardName, bundle: nil)
    }

    static func initialViewController() -> UIViewController {
        return storyboard().instantiateInitialViewController()!
    }
}

extension StoryboardSceneType where Self: RawRepresentable, Self.RawValue == String {
    func viewController() -> UIViewController {
        return Self.storyboard().instantiateViewController(withIdentifier: self.rawValue)
    }
    static func viewController(_ identifier: Self) -> UIViewController {
        return identifier.viewController()
    }
}

protocol StoryboardSegueType: RawRepresentable { }

extension UIViewController {
    func performSegue<S: StoryboardSegueType>(_ segue: S, sender: AnyObject? = nil) where S.RawValue == String {
        self.performSegue(withIdentifier: segue.rawValue, sender: sender)
    }
}

struct StoryboardScene {
    enum GameHistory: String, StoryboardSceneType {
        static let storyboardName = "GameHistory"

        case CarnageReportViewControllerIdentifierScene = "CarnageReportViewControllerIdentifier"
        static func carnageReportViewController() -> CarnageReportViewController {
            return StoryboardScene.GameHistory.CarnageReportViewControllerIdentifierScene.viewController() as! CarnageReportViewController
        }

        case GameHistoryViewControllerIdentifierScene = "GameHistoryViewControllerIdentifier"
        static func gameHistoryViewController() -> GameHistoryViewController {
            return StoryboardScene.GameHistory.GameHistoryViewControllerIdentifierScene.viewController() as! GameHistoryViewController
        }

        case PlayerCarnageReportViewControllerScene = "PlayerCarnageReportViewController"
        static func playerCarnageReportViewController() -> PlayerCarnageReportViewController {
            return StoryboardScene.GameHistory.PlayerCarnageReportViewControllerScene.viewController() as! PlayerCarnageReportViewController
        }

        case MatchFilterViewControllerScene = "MatchFilterViewController"
        static func matchFilterViewController() -> MatchFilterViewController {
            return StoryboardScene.GameHistory.MatchFilterViewControllerScene.viewController() as! MatchFilterViewController
        }
    }
    enum LaunchScreen: StoryboardSceneType {
        static let storyboardName = "LaunchScreen"
    }
    enum Main: StoryboardSceneType {
        static let storyboardName = "Main"
    }
    enum SignIn: String, StoryboardSceneType {
        static let storyboardName = "SignIn"

        case LaunchViewControllerScene = "LaunchViewController"
        static func launchViewController() -> LaunchViewController {
            return StoryboardScene.SignIn.LaunchViewControllerScene.viewController() as! LaunchViewController
        }
    }
    enum PlayerComparison: String, StoryboardSceneType {
        static let storyboardName = "PlayerComparison"

        static func playerComparisonViewController() -> PlayerComparisonViewController {
            return StoryboardScene.PlayerComparison.initialViewController() as! PlayerComparisonViewController
        }

        case SpartansViewControllerScene = "SpartansViewController"
        static func spartansViewController() -> SpartansViewController {
            return StoryboardScene.PlayerComparison.SpartansViewControllerScene.viewController() as! SpartansViewController
        }

        case ComparisonTableViewControllerScene = "ComparisonTableViewController"
        static func comparisonTableViewController() -> ComparisonTableViewController {
            return StoryboardScene.PlayerComparison.ComparisonTableViewControllerScene.viewController() as! ComparisonTableViewController
        }
    }
    enum PlayerStats: String, StoryboardSceneType {
        static let storyboardName = "PlayerStats"

        static func playerStatsParentViewController() -> PlayerStatsParentViewController {
            return StoryboardScene.PlayerStats.initialViewController() as! PlayerStatsParentViewController
        }

        case ServiceRecordTableViewControllerIdentifierScene = "ServiceRecordTableViewControllerIdentifier"
        static func serviceRecordTableViewController() -> ServiceRecordViewController {
            return StoryboardScene.PlayerStats.ServiceRecordTableViewControllerIdentifierScene.viewController() as! ServiceRecordViewController
        }

        case AllMedalsViewControllerScene = "AllMedalsViewController"
        static func allMedalsViewController() -> AllMedalsViewController {
            return StoryboardScene.PlayerStats.AllMedalsViewControllerScene.viewController() as! AllMedalsViewController
        }

        case MedalDetailViewControllerScene = "MedalDetailViewController"
        static func medalDetailViewController() -> MedalDetailViewController {
            return StoryboardScene.PlayerStats.MedalDetailViewControllerScene.viewController() as! MedalDetailViewController
        }
    }
    enum Settings: StoryboardSceneType {
        static let storyboardName = "Settings"

        static func settingsViewController() -> SettingsViewController {
            return StoryboardScene.Settings.initialViewController() as! SettingsViewController
        }
    }
    enum Weapons: String, StoryboardSceneType {
        static let storyboardName = "Weapons"

        static func weaponsViewController() -> WeaponsViewController {
            return StoryboardScene.Weapons.initialViewController() as! WeaponsViewController
        }

        case WeaponStatsDetailViewControllerScene = "WeaponStatsDetailViewController"
        static func weaponStatsDetailViewController() -> WeaponStatsDetailViewController {
            return StoryboardScene.Weapons.WeaponStatsDetailViewControllerScene.viewController() as! WeaponStatsDetailViewController
        }

        case WeaponsFilterViewControllerScene = "WeaponsFilterViewController"
        static func weaponsFilterViewController() -> WeaponsFilterViewController {
            return StoryboardScene.Weapons.WeaponsFilterViewControllerScene.viewController() as! WeaponsFilterViewController
        }
    }
}

struct StoryboardSegue {
    enum PlayerStats: String, StoryboardSegueType {
        case EmbedServiceRecord = "EmbedServiceRecordPageViewController"
    }
}
