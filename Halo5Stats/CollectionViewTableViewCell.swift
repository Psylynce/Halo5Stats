//
//  CollectionViewTableViewCell.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class CollectionViewTableViewCell: UITableViewCell {

    struct K {
        static let BasicScoreCell = "BasicScoreCell"
        static let TitleScoreCell = "TitleScoreCell"
        static let PlayerStatCell = "PlayerStatCell"
        static let SimpleWeaponCell = "SimpleWeaponCell"
    }
    
    @IBOutlet weak var collectionView: UICollectionView!

    var isScrolling: Bool = false
    let medalImageManager = MedalImageManager()
    let imageManager = ImageManager()
    var dataSource: ScoreCollectionViewDataSource!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.scrollsToTop = false
        collectionView.backgroundColor = UIColor.clearColor()

        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false

        collectionView.registerNib(UINib(nibName: K.BasicScoreCell, bundle: nil), forCellWithReuseIdentifier: K.BasicScoreCell)
        collectionView.registerNib(UINib(nibName: K.TitleScoreCell, bundle: nil), forCellWithReuseIdentifier: K.TitleScoreCell)
        collectionView.registerNib(UINib(nibName: K.PlayerStatCell, bundle: nil), forCellWithReuseIdentifier: K.PlayerStatCell)
        collectionView.registerNib(UINib(nibName: K.SimpleWeaponCell, bundle: nil), forCellWithReuseIdentifier: K.SimpleWeaponCell)

        selectionStyle = .None

        contentView.backgroundColor = UIColor.clearColor()
        backgroundColor = UIColor.clearColor()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        collectionView.reloadData()
    }

    private func lastTwoItems(indexPath: NSIndexPath) -> Bool {
        let lastItem = indexPath.item == dataSource.items.count - 1
        let secondToLastItem = indexPath.item == dataSource.items.count - 2
        let lastTwoItems = lastItem || secondToLastItem

        return lastTwoItems
    }

    func updateVisibleCells() {
        guard let dataSource = dataSource where dataSource.type == .Medals || dataSource.type == .WeaponStats else { return }

        for cell in collectionView.visibleCells() {
            if let cell = cell as? MedalImagePresenter {
                cell.initiateMedalImageRequest(self)
            }

            if let cell = cell as? ImagePresenter {
                cell.initiateImageRequest(self)
            }
        }
    }
}

extension CollectionViewTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.items.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let item = dataSource.items[indexPath.item]

        switch dataSource.type {
        case .EnemyAIKills, .TeamScore, .VehicleKills:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(K.BasicScoreCell, forIndexPath: indexPath) as! BasicScoreCell
            cell.configure(item)

            return cell
        case .PlayerScore:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(K.TitleScoreCell, forIndexPath: indexPath) as! TitleScoreCell
            cell.configure(item)

            return cell
        case .Medals:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(K.TitleScoreCell, forIndexPath: indexPath) as! TitleScoreCell
            if let medal = item as? MedalModel {
                cell.medal = medal
                cell.configure(item, cachedImage: medalImageManager.cachedMedalImage(medal))
            }

            return cell
        case .PlayerStats:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(K.PlayerStatCell, forIndexPath: indexPath) as! PlayerStatCell
            cell.configure(item)
            cell.hideBorder(forIndex: indexPath.item)
            if indexPath.item == dataSource.items.count - 1 || indexPath.item == dataSource.items.count - 2 {
                cell.completelyHideBorder()
            }

            return cell
        case .WeaponStats:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(K.SimpleWeaponCell, forIndexPath: indexPath) as! SimpleWeaponCell
            if let weapon = item as? WeaponModel {
                cell.weapon = weapon
                let weaponImage = imageManager.cachedImage(weapon)
                cell.configure(item, cachedImage: weaponImage)
            }

            return cell
        }
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let items = dataSource.items
        let itemCount = CGFloat(items.count)

        if dataSource.type == .Medals {
            if items.count == 5 {
                return CGSize(width: collectionView.frame.width / itemCount, height: collectionView.frame.height)
            }
        } else if dataSource.type == .WeaponStats {
            return CGSize(width: collectionView.frame.width / 2.25, height: collectionView.frame.height)
        }

        if items.count <= 4 && items.count != 0 {
            return CGSize(width: collectionView.frame.width / itemCount, height: collectionView.frame.height)
        } else {
            let isPlayerStats = dataSource.type == .PlayerStats
            if isPlayerStats {
                let height: CGFloat = 100.0
                let divisor: CGFloat = lastTwoItems(indexPath) ? 2.0 : 3.0
                return CGSize(width: (collectionView.frame.width / divisor) - 1, height: height)
            }

            return CGSize(width: collectionView.frame.width / 4.5, height: collectionView.frame.height)
        }
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat.min
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat.min
    }
}

extension CollectionViewTableViewCell: ImageRequestFetchCoordinator {

    func fetchImage(presenter: ImagePresenter, model: CacheableImageModel) {
        imageManager.fetchImage(model) { (model, image) in
            if let image = image {
                dispatch_async(dispatch_get_main_queue(), {
                    presenter.displayImage(model, image: image)
                })
            }
        }
    }
}
extension CollectionViewTableViewCell: MedalImageRequestFetchCoordinator {

    func fetchMedalImage(presenter: MedalImagePresenter, medal: MedalModel) {
        medalImageManager.fetchMedalImage(medal) { (medal, image) in
            if let image = image {
                dispatch_async(dispatch_get_main_queue(), {
                    presenter.displayMedalImage(medal, image: image)
                })
            }
        }
    }
}

extension CollectionViewTableViewCell: UIScrollViewDelegate {

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
