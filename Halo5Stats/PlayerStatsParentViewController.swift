//
//  PlayerStatsParentViewController.swift
//  Halo5Stats
//
//  Copyright © 2015 Justin Powell. All rights reserved.
//

import UIKit
import Foundation

class PlayerStatsParentViewController: UIViewController {

    @IBOutlet var headerView: SpartanStatsHeaderView!
    @IBOutlet var spartanImageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var headerViewHeightConstraint: NSLayoutConstraint!

    struct Layout {
        static let maxHeaderHeight: CGFloat = 250
        static let minHeaderHeight: CGFloat = 110

        static let defaultSpartanImageViewTop: CGFloat = 35
        static let shrunkenSpartanImageViewTop: CGFloat = -100

        static let defaultBlurAlpha: CGFloat = 0
        static let shrunkenBlurAlpha: CGFloat = 1
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        setupAppearance()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setupHeader()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.presentTransparentNavigationBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.hideTransparentNavigationBar()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let id = segue.identifier, let statsSegue = StoryboardSegue.PlayerStats(rawValue: id) else { return }
        switch statsSegue {
        case .EmbedServiceRecord:
            pageViewController = (segue.destination as! UIPageViewController)
        }
    }

    deinit {
        removeGamertagWatcher()
    }

    // MARK: - PageViewController View Controllers

    lazy var arenaServiceRecordViewController = StoryboardScene.PlayerStats.serviceRecordTableViewController()
    lazy var warzoneServiceRecordViewController = StoryboardScene.PlayerStats.serviceRecordTableViewController()
    lazy var customServiceRecordViewController = StoryboardScene.PlayerStats.serviceRecordTableViewController()
    fileprivate var viewControllers: [ServiceRecordViewController] = []
    fileprivate var currentIndex: Int = 0 {
        didSet {
            if let viewController = viewControllers[safe: currentIndex] {
                headerView.animate(with: viewController, currentIndex: currentIndex)
            }
        }
    }
    fileprivate var shouldCollapseHeader: Bool = true

    fileprivate func setupPageViewController() {
        pageViewController.view.backgroundColor = .cinder
        pageViewController.delegate = self
        pageViewController.dataSource = self

        arenaServiceRecordViewController.viewModel = ServiceRecordViewModel(gameMode: .arena, gamertag: viewModel.gamertag)
        warzoneServiceRecordViewController.viewModel = ServiceRecordViewModel(gameMode: .warzone, gamertag: viewModel.gamertag)
        customServiceRecordViewController.viewModel = ServiceRecordViewModel(gameMode: .custom, gamertag: viewModel.gamertag)

        arenaServiceRecordViewController.delegate = self
        warzoneServiceRecordViewController.delegate = self
        customServiceRecordViewController.delegate = self

        viewControllers = [arenaServiceRecordViewController, warzoneServiceRecordViewController, customServiceRecordViewController]
        pageViewController.setViewControllers([viewControllers[0]], direction: .forward, animated: true) { (_) in }
    }

    // MARK: - PlayerStatsParentViewController

    var pageViewController: UIPageViewController!
    var viewModel = PlayerStatsParentViewModel()

    fileprivate func setupAppearance() {
        setupPageViewController()
        setupHeader()
    }

    fileprivate func setupHeader() {
        let vc = viewControllers[safe: currentIndex]

        headerView.delegate = self
        headerView.configure(with: viewModel, gameMode: vc?.viewModel.gameMode)

        hideBackButtonTitle()
    }

    fileprivate func updatePageViewController(for gameMode: GameMode) {
        var newIndex = 0

        switch gameMode {
        case .arena:
            if currentIndex == 1 {
                pageViewController.setViewControllers([viewControllers[0]], direction: .reverse, animated: true, completion: nil)
            } else if currentIndex == 2 {
                pageViewController.setViewControllers([viewControllers[1]], direction: .reverse, animated: true, completion: nil)
                pageViewController.setViewControllers([viewControllers[0]], direction: .reverse, animated: true, completion: nil)
            }

            newIndex = 0
        case .warzone:
            if currentIndex == 0 {
                pageViewController.setViewControllers([viewControllers[1]], direction: .forward, animated: true, completion: nil)
            } else if currentIndex == 2 {
                pageViewController.setViewControllers([viewControllers[1]], direction: .reverse, animated: true, completion: nil)
            }

            newIndex = 1
        case .custom:
            if currentIndex == 0 {
                pageViewController.setViewControllers([viewControllers[1]], direction: .forward, animated: true, completion: nil)
                pageViewController.setViewControllers([viewControllers[2]], direction: .forward, animated: true, completion: nil)
            } else if currentIndex == 1 {
                pageViewController.setViewControllers([viewControllers[2]], direction: .forward, animated: true, completion: nil)
            }

            newIndex = 2
        }

        currentIndex = newIndex
    }

    func collapse() {
        headerViewHeightConstraint.constant = Layout.minHeaderHeight
        spartanImageViewTopConstraint.constant = Layout.shrunkenSpartanImageViewTop

        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            self.headerView.effectView.alpha = Layout.shrunkenBlurAlpha
            self.headerView.spartanImageView.layer.transform = CATransform3DMakeScale(0, 0, 0)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    func expand() {
        headerViewHeightConstraint.constant = Layout.maxHeaderHeight
        spartanImageViewTopConstraint.constant = Layout.defaultSpartanImageViewTop

        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            self.headerView.effectView.alpha = Layout.defaultBlurAlpha
            self.headerView.spartanImageView.layer.transform = CATransform3DMakeScale(1, 1, 0)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension PlayerStatsParentViewController: SpartanStatsHeaderViewDelegate {

    func didTapButton(for gameMode: GameMode?) {
        guard let mode = gameMode else { return }
        updatePageViewController(for: mode)
    }
}

extension PlayerStatsParentViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? ServiceRecordViewController, var index = viewControllers.index(of: vc) else { return nil }

        index += 1
        if index >= viewControllers.count {
            return nil
        }

        return viewControllers[index]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? ServiceRecordViewController, var index = viewControllers.index(of: vc) else { return nil }

        if index <= 0 {
            return nil
        }
        index -= 1

        return viewControllers[index]
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let currentViewController = pageViewController.viewControllers?.last as? ServiceRecordViewController else { return }
        currentIndex = viewControllers.index(of: currentViewController)!
    }
}

extension PlayerStatsParentViewController: ServiceRecordScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        
        if offset > 0 && shouldCollapseHeader {
            collapse()
            shouldCollapseHeader = false
        } else if offset < 0 && !shouldCollapseHeader {
            expand()
            shouldCollapseHeader = true
        }
    }
}

extension PlayerStatsParentViewController: GamertagWatcher {

    func defaultGamertagChanged(_ notification: Notification) {
        viewModel = PlayerStatsParentViewModel()
        currentIndex = 0
        _ = navigationController?.popToRootViewController(animated: false)
        setupAppearance()
    }
}
