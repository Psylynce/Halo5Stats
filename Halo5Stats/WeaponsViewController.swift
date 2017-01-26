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
    fileprivate var isScrolling: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setupAppearance()
        setupTableView()
        setupBindAndFires()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        updateVisibleCells()
    }

    // MARK: Private

    fileprivate var filterButton: UIBarButtonItem {
        let filterButtonImage = UIImage(named: "Filter")?.withRenderingMode(.alwaysTemplate)
        let filterButton = UIBarButtonItem(image: filterButtonImage, style: .plain, target: self, action: #selector(filterButtonTapped))
        filterButton.tintColor = UIColor(haloColor: .WhiteSmoke)
        return filterButton
    }

    fileprivate func setupBindAndFires() {
        viewModel.selectedFilter.bindAndFire { [weak self] (_) in
            self?.viewModel.filterWeapons()
            self?.tableView.reloadData()
        }
    }

    fileprivate func setupAppearance() {
        navigationItem.rightBarButtonItem = filterButton
    }

    fileprivate func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor(haloColor: .Cinder)
    }

    @objc fileprivate func filterButtonTapped() {
        let vc = StoryboardScene.Weapons.weaponsFilterViewController()
        vc.modalPresentationStyle = .popover
        vc.preferredContentSize = CGSize(width: 250, height: 308)
        vc.popoverPresentationController?.delegate = self
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        vc.delegate = self

        if let option = viewModel.selectedFilter.value {
            vc.viewModel.selectedOption.value = option
        }

        present(vc, animated: true, completion: nil)
    }

    fileprivate func updateVisibleCells() {
        for cell in tableView.visibleCells {
            if let cell = cell as? ImagePresenter {
                cell.initiateImageRequest(self)
            }
        }
    }
}

extension WeaponsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.weapons.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let weapon = viewModel.weapons[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeaponCell", for: indexPath) as! WeaponStatsCell
        let isEven = indexPath.row % 2 == 0
        cell.weapon = weapon
        cell.configure(viewModel.imageManager.cachedImage(weapon), isEven: isEven)
    
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let weapon = viewModel.weapons[indexPath.row]
        let vc = StoryboardScene.Weapons.weaponStatsDetailViewController()
        vc.viewModel = WeaponStatsDetailViewModel(weapon: weapon, gameMode: viewModel.gameMode, imageManager: viewModel.imageManager)

        navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension WeaponsViewController: WeaponsFilterDelegate {
    func selectedFilter(_ option: WeaponsFilterViewModel.FilterOption) {
        viewModel.selectedFilter.value = option
    }
}

extension WeaponsViewController: ImageRequestFetchCoordinator {
    func fetchImage(_ presenter: ImagePresenter, model: CacheableImageModel) {
        viewModel.imageManager.fetchImage(model) { (model, image) in
            if let image = image {
                DispatchQueue.main.async(execute: {
                    presenter.displayImage(model, image: image)
                })
            }
        }
    }
}

extension WeaponsViewController: UIScrollViewDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isScrolling = true
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            isScrolling = false
        }

        if !isScrolling && scrollView == tableView {
            updateVisibleCells()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isScrolling = false

        if !isScrolling && scrollView == tableView {
            updateVisibleCells()
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let indexPaths = tableView.indexPathsForVisibleRows {
            for indexPath in indexPaths {
                if let cell = tableView.cellForRow(at: indexPath) as? ParallaxScrollingCell {
                    cellImageOffset(tableView, cell: cell, indexPath: indexPath)
                }
            }
        }
    }
}

extension WeaponsViewController: UIPopoverPresentationControllerDelegate {

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
