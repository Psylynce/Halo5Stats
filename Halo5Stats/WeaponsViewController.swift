//
//  WeaponsViewController.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class WeaponsViewController: UIViewController, ParallaxScrollingTableView {
    
    @IBOutlet var tableView: UITableView!

    var viewModel: WeaponsViewModel!
    private var isScrolling: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setupAppearance()
        setupTableView()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        updateVisibleCells()
    }

    // MARK: Private

    private func setupAppearance() {
        let filterButtonImage = UIImage(named: "Filter")?.imageWithRenderingMode(.AlwaysTemplate)
        let filterButton = UIBarButtonItem(image: filterButtonImage, style: .Plain, target: self, action: #selector(filterButtonTapped))
        filterButton.tintColor = UIColor(haloColor: .WhiteSmoke)
        navigationItem.rightBarButtonItem = filterButton
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor(haloColor: .Cinder)
    }

    @objc private func filterButtonTapped() {

    }

    private func updateVisibleCells() {
        for cell in tableView.visibleCells {
            if let cell = cell as? ImagePresenter {
                cell.initiateImageRequest(self)
            }
        }
    }
}

extension WeaponsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.weapons.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let weapon = viewModel.weapons[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("WeaponCell", forIndexPath: indexPath) as! WeaponStatsCell
        let isEven = indexPath.row % 2 == 0
        cell.weapon = weapon
        cell.configure(viewModel.imageManager.cachedImage(weapon), isEven: isEven)
    
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let weapon = viewModel.weapons[indexPath.row]
        let vc = StoryboardScene.Weapons.weaponStatsDetailViewController()
        vc.viewModel = WeaponStatsDetailViewModel(weapon: weapon, gameMode: viewModel.gameMode, imageManager: viewModel.imageManager)

        navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }
}

extension WeaponsViewController: ImageRequestFetchCoordinator {
    func fetchImage(presenter: ImagePresenter, model: CacheableImageModel) {
        viewModel.imageManager.fetchImage(model) { (model, image) in
            if let image = image {
                dispatch_async(dispatch_get_main_queue(), {
                    presenter.displayImage(model, image: image)
                })
            }
        }
    }
}

extension WeaponsViewController: UIScrollViewDelegate {

    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        isScrolling = true
    }

    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            isScrolling = false
        }

        if !isScrolling && scrollView == tableView {
            updateVisibleCells()
        }
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        isScrolling = false

        if !isScrolling && scrollView == tableView {
            updateVisibleCells()
        }
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        if let indexPaths = tableView.indexPathsForVisibleRows {
            for indexPath in indexPaths {
                if let cell = tableView.cellForRowAtIndexPath(indexPath) as? ParallaxScrollingCell {
                    cellImageOffset(tableView, cell: cell, indexPath: indexPath)
                }
            }
        }
    }
}
