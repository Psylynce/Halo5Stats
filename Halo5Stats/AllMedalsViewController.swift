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

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        updateVisibleCells()
    }

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func setupAppearance() {
        hideBackButtonTitle()
    }

    private func updateVisibleCells() {
        for cell in collectionView.visibleCells() {
            if let cell = cell as? MedalImagePresenter {
                cell.initiateMedalImageRequest(self)
            }
        }
    }
}

extension AllMedalsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.allMedals.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let medal = viewModel.allMedals[indexPath.item]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MedalListCell", forIndexPath: indexPath) as! MedalListCell
        cell.medal = medal
        cell.configure(viewModel.imageManager.cachedMedalImage(medal))

        return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? MedalListCell else { return }
        let medal = cell.medal

        let cellFrame = cell.convertRect(cell.medalImageView.frame, toView: collectionView)
        let frame = collectionView.convertRect(cellFrame, toView: view.superview)

        let detailVC = StoryboardScene.PlayerStats.medalDetailViewController()
        detailVC.viewModel = MedalDetailViewModel(medal: medal, imageManager: viewModel.imageManager)
        detailVC.openingFrame = frame
        detailVC.modalPresentationStyle = .OverFullScreen
        
        presentViewController(detailVC, animated: false, completion: nil)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width: CGFloat = collectionView.bounds.width / 5.0
        let height: CGFloat = 75

        return CGSize(width: width, height: height)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
}

extension AllMedalsViewController: MedalImageRequestFetchCoordinator {

    func fetchMedalImage(presenter: MedalImagePresenter, medal: MedalModel) {
        viewModel.imageManager.fetchMedalImage(medal) { (medal, image) in
            if let image = image {
                dispatch_async(dispatch_get_main_queue(), { 
                    presenter.displayMedalImage(medal, image: image)
                })
            }
        }
    }
}

extension AllMedalsViewController: UIScrollViewDelegate {

    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        isScrolling = true
    }

    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            isScrolling = false
        }

        if !isScrolling && scrollView == collectionView {
            updateVisibleCells()
        }
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        isScrolling = false

        if !isScrolling && scrollView == collectionView {
            updateVisibleCells()
        }
    }
}
