//
//  PlayerStatsParentViewController.swift
//  Halo5Stats
//
//  Copyright © 2015 Justin Powell. All rights reserved.
//

import UIKit
import Foundation

class PlayerStatsParentViewController: UIViewController {

    @IBOutlet var headerView: UIView!
    @IBOutlet var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var headerImageView: UIImageView!
    @IBOutlet var spartanImageView: CircleImageView!
    @IBOutlet var spartanImageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var emblemImageView: UIImageView!
    @IBOutlet var gamertagLabel: UILabel!
    
    @IBOutlet weak var buttonContainerView: UIView!
    @IBOutlet weak var arenaButton: UIButton!
    @IBOutlet weak var warzoneButton: UIButton!
    @IBOutlet weak var customButton: UIButton!
    @IBOutlet var buttons: [UIButton]!

    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var sliderViewLeadingConstraint: NSLayoutConstraint!

    struct K {
        static let defaultHeaderHeight: CGFloat = 250
        static let shrunkenHeaderHeight: CGFloat = 110

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
            pageViewController = segue.destination as! UIPageViewController
        }
    }

    deinit {
        removeGamertagWatcher()
    }

    // MARK: - PageViewController View Controllers

    lazy var arenaServiceRecordViewController = StoryboardScene.PlayerStats.serviceRecordTableViewController()
    lazy var warzoneServiceRecordViewController = StoryboardScene.PlayerStats.serviceRecordTableViewController()
    lazy var customServiceRecordViewController = StoryboardScene.PlayerStats.serviceRecordTableViewController()
    fileprivate var viewControllers: [UIViewController] = []
    fileprivate var currentIndex: Int = 0 {
        didSet {
            animateHeader()
        }
    }

    fileprivate func setupPageViewController() {
        pageViewController.view.backgroundColor = UIColor(haloColor: .Cinder)
        pageViewController.delegate = self
        pageViewController.dataSource = self

        arenaServiceRecordViewController.viewModel = ServiceRecordViewModel(gameMode: .Arena, gamertag: viewModel.gamertag)
        warzoneServiceRecordViewController.viewModel = ServiceRecordViewModel(gameMode: .Warzone, gamertag: viewModel.gamertag)
        customServiceRecordViewController.viewModel = ServiceRecordViewModel(gameMode: .Custom, gamertag: viewModel.gamertag)

        arenaServiceRecordViewController.delegate = self
        warzoneServiceRecordViewController.delegate = self
        customServiceRecordViewController.delegate = self

        viewControllers = [arenaServiceRecordViewController, warzoneServiceRecordViewController, customServiceRecordViewController]
        pageViewController.setViewControllers([viewControllers[0]], direction: .forward, animated: true) { (_) in }
    }

    // MARK: - PlayerStatsParentViewController

    var pageViewController: UIPageViewController!
    var viewModel = PlayerStatsParentViewModel()

    fileprivate var shouldShrinkHeader: Bool = true
    fileprivate var effectView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: blur)
        effectView.alpha = K.defaultBlurAlpha

        return effectView
    }()

    fileprivate func setupAppearance() {
        setupPageViewController()
        setupButtons()
        setupSlider()
        setupHeader()
    }

    fileprivate func setupHeader() {
        headerImageView.contentMode = .scaleAspectFill
        effectView.frame = view.bounds
        headerImageView.addSubview(effectView)

        if let gamertag = viewModel.gamertag {
            spartanImageView.spartanHeadImage(forGamertag: gamertag)
            emblemImageView.image(forUrl: ProfileService.emblemUrl(forGamertag: gamertag))
            gamertagLabel.text = viewModel.spartan()?.displayGamertag ?? gamertag
        } else {
            gamertagLabel.text = ""
        }

        if let vc = viewControllers[currentIndex] as? ServiceRecordViewController {
            spartanImageView.updateBorderColor(with: vc.viewModel.gameMode.color)
            headerImageView.image = vc.viewModel.gameMode.image
        }

        gamertagLabel.textColor = UIColor(haloColor: .WhiteSmoke)
        gamertagLabel.font = UIFont.kelson(.Regular, size: 24)
        gamertagLabel.adjustsFontSizeToFitWidth = true
        gamertagLabel.minimumScaleFactor = 0.5

        hideBackButtonTitle()
    }

    fileprivate func setupButtons() {
        buttons.forEach {
            $0.setTitleColor(UIColor(haloColor: .WhiteSmoke), for: UIControlState())
            $0.titleLabel?.font = UIFont.kelson(.Regular, size: 18.0)
        }

        arenaButton.setTitle("Arena", for: UIControlState())
        warzoneButton.setTitle("Warzone", for: UIControlState())
        customButton.setTitle("Custom", for: UIControlState())
    }

    fileprivate func setupSlider() {
        guard let vc = viewControllers[currentIndex] as? ServiceRecordViewController else { return }
        sliderView.backgroundColor = vc.viewModel.gameMode.color
    }

    @IBAction func arenaButtonTapped(_ sender: UIButton) {
        if currentIndex == 1 {
            pageViewController.setViewControllers([viewControllers[0]], direction: .reverse, animated: true, completion: nil)
        } else if currentIndex == 2 {
            pageViewController.setViewControllers([viewControllers[1]], direction: .reverse, animated: true, completion: nil)
            pageViewController.setViewControllers([viewControllers[0]], direction: .reverse, animated: true, completion: nil)
        }
        currentIndex = 0
    }

    @IBAction func warzoneButtonTapped(_ sender: UIButton) {
        if currentIndex == 0 {
            pageViewController.setViewControllers([viewControllers[1]], direction: .forward, animated: true, completion: nil)
        } else if currentIndex == 2 {
            pageViewController.setViewControllers([viewControllers[1]], direction: .reverse, animated: true, completion: nil)
        }
        currentIndex = 1
    }

    @IBAction func customButtonTapped(_ sender: UIButton) {
        if currentIndex == 0 {
            pageViewController.setViewControllers([viewControllers[1]], direction: .forward, animated: true, completion: nil)
            pageViewController.setViewControllers([viewControllers[2]], direction: .forward, animated: true, completion: nil)
        } else if currentIndex == 1 {
            pageViewController.setViewControllers([viewControllers[2]], direction: .forward, animated: true, completion: nil)
        }
        currentIndex = 2
    }

    fileprivate func animateHeader() {
        guard let vc = viewControllers[currentIndex] as? ServiceRecordViewController else { return }

        spartanImageView.updateBorderColor(with: vc.viewModel.gameMode.color)
        UIView.transition(with: headerImageView, duration: 0.3, options: .transitionCrossDissolve, animations: { [weak self] in
            self?.headerImageView.image = vc.viewModel.gameMode.image
            }, completion: nil)

        sliderViewLeadingConstraint.constant = CGFloat(currentIndex) * sliderView.bounds.width

        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.sliderView.backgroundColor = vc.viewModel.gameMode.color
            self.view.layoutIfNeeded()
            }, completion: nil)
    }

    fileprivate func shrinkHeaderView() {
        headerViewHeightConstraint.constant = K.shrunkenHeaderHeight
        spartanImageViewTopConstraint.constant = K.shrunkenSpartanImageViewTop

        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.effectView.alpha = K.shrunkenBlurAlpha
            self.spartanImageView.layer.transform = CATransform3DMakeScale(0, 0, 0)
            self.view.layoutIfNeeded()
            }, completion: nil)
    }

    fileprivate func expandHeaderView() {
        headerViewHeightConstraint.constant = K.defaultHeaderHeight
        spartanImageViewTopConstraint.constant = K.defaultSpartanImageViewTop

        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.effectView.alpha = K.defaultBlurAlpha
            self.spartanImageView.layer.transform = CATransform3DMakeScale(1, 1, 0)
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
}

extension PlayerStatsParentViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard var index = viewControllers.index(of: viewController) else { return nil }

        index += 1
        if index >= viewControllers.count {
            return nil
        }

        return viewControllers[index]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard var index = viewControllers.index(of: viewController) else { return nil }

        if index <= 0 {
            return nil
        }
        index -= 1

        return viewControllers[index]
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let currentViewController = pageViewController.viewControllers?.last else { return }
        currentIndex = viewControllers.index(of: currentViewController)!
    }
}

extension PlayerStatsParentViewController: ServiceRecordScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        
        if offset > 0 && shouldShrinkHeader {
            shrinkHeaderView()
            shouldShrinkHeader = false
        } else if offset < 0 && !shouldShrinkHeader {
            expandHeaderView()
            shouldShrinkHeader = true
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
