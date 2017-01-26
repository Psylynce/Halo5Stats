//
//  AllMedalsViewController.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class AllMedalsViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!

    var viewModel: AllMedalsViewModel!
    var isScrolling: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupAppearance()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        updateVisibleCells()
    }

    fileprivate func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    fileprivate func setupAppearance() {
        hideBackButtonTitle()
    }

    fileprivate func updateVisibleCells() {
        for cell in collectionView.visibleCells {
            if let cell = cell as? MedalImagePresenter {
                cell.initiateMedalImageRequest(self)
            }
        }
    }
}

extension AllMedalsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.allMedals.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let medal = viewModel.allMedals[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MedalListCell", for: indexPath) as! MedalListCell
        cell.medal = medal
        cell.configure(viewModel.imageManager.cachedMedalImage(medal))

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MedalListCell else { return }
        let medal = cell.medal

        let cellFrame = cell.convert(cell.medalImageView.frame, to: collectionView)
        let frame = collectionView.convert(cellFrame, to: view.superview)

        let detailVC = StoryboardScene.PlayerStats.medalDetailViewController()
        detailVC.viewModel = MedalDetailViewModel(medal: medal!, imageManager: viewModel.imageManager)
        detailVC.openingFrame = frame
        detailVC.modalPresentationStyle = .overFullScreen
        
        present(detailVC, animated: false, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.bounds.width / 5.0
        let height: CGFloat = 75

        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension AllMedalsViewController: MedalImageRequestFetchCoordinator {

    func fetchMedalImage(_ presenter: MedalImagePresenter, medal: MedalModel) {
        viewModel.imageManager.fetchMedalImage(medal) { (medal, image) in
            if let image = image {
                DispatchQueue.main.async(execute: { 
                    presenter.displayMedalImage(medal, image: image)
                })
            }
        }
    }
}

extension AllMedalsViewController: UIScrollViewDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isScrolling = true
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            isScrolling = false
        }

        if !isScrolling && scrollView == collectionView {
            updateVisibleCells()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isScrolling = false

        if !isScrolling && scrollView == collectionView {
            updateVisibleCells()
        }
    }
}
