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
        collectionView.backgroundColor = UIColor.clear

        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false

        collectionView.register(UINib(nibName: K.BasicScoreCell, bundle: nil), forCellWithReuseIdentifier: K.BasicScoreCell)
        collectionView.register(UINib(nibName: K.TitleScoreCell, bundle: nil), forCellWithReuseIdentifier: K.TitleScoreCell)
        collectionView.register(UINib(nibName: K.PlayerStatCell, bundle: nil), forCellWithReuseIdentifier: K.PlayerStatCell)
        collectionView.register(UINib(nibName: K.SimpleWeaponCell, bundle: nil), forCellWithReuseIdentifier: K.SimpleWeaponCell)

        selectionStyle = .none

        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        collectionView.reloadData()
    }

    fileprivate func lastTwoItems(_ indexPath: IndexPath) -> Bool {
        let lastItem = indexPath.item == dataSource.items.count - 1
        let secondToLastItem = indexPath.item == dataSource.items.count - 2
        let lastTwoItems = lastItem || secondToLastItem

        return lastTwoItems
    }

    func updateVisibleCells() {
        guard let dataSource = dataSource, dataSource.type == .medals || dataSource.type == .weaponStats else { return }

        for cell in collectionView.visibleCells {
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

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = dataSource.items[indexPath.item]

        switch dataSource.type {
        case .enemyAIKills, .teamScore, .vehicleKills:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.BasicScoreCell, for: indexPath) as! BasicScoreCell
            cell.configure(item)

            return cell
        case .playerScore:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.TitleScoreCell, for: indexPath) as! TitleScoreCell
            cell.configure(item)

            return cell
        case .medals:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.TitleScoreCell, for: indexPath) as! TitleScoreCell
            if let medal = item as? MedalModel {
                cell.medal = medal
                cell.configure(item, cachedImage: medalImageManager.cachedMedalImage(medal))
            }

            return cell
        case .playerStats:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.PlayerStatCell, for: indexPath) as! PlayerStatCell
            cell.configure(item)
            cell.hideBorder(forIndex: indexPath.item)
            if indexPath.item == dataSource.items.count - 1 || indexPath.item == dataSource.items.count - 2 {
                cell.completelyHideBorder()
            }

            return cell
        case .weaponStats:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.SimpleWeaponCell, for: indexPath) as! SimpleWeaponCell
            if let weapon = item as? WeaponModel {
                cell.weapon = weapon
                let weaponImage = imageManager.cachedImage(weapon)
                cell.configure(item, cachedImage: weaponImage)
            }

            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let items = dataSource.items
        let itemCount = CGFloat(items.count)

        if dataSource.type == .medals {
            if items.count == 5 {
                return CGSize(width: collectionView.frame.width / itemCount, height: collectionView.frame.height)
            }
        } else if dataSource.type == .weaponStats {
            return CGSize(width: collectionView.frame.width / 2.25, height: collectionView.frame.height)
        }

        if items.count <= 4 && items.count != 0 {
            return CGSize(width: collectionView.frame.width / itemCount, height: collectionView.frame.height)
        } else {
            let isPlayerStats = dataSource.type == .playerStats
            if isPlayerStats {
                let height: CGFloat = 100.0
                let divisor: CGFloat = lastTwoItems(indexPath) ? 2.0 : 3.0
                return CGSize(width: (collectionView.frame.width / divisor) - 1, height: height)
            }

            return CGSize(width: collectionView.frame.width / 4.5, height: collectionView.frame.height)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}

extension CollectionViewTableViewCell: ImageRequestFetchCoordinator {

    func fetchImage(_ presenter: ImagePresenter, model: CacheableImageModel) {
        imageManager.fetchImage(model) { (model, image) in
            if let image = image {
                DispatchQueue.main.async(execute: {
                    presenter.displayImage(model, image: image)
                })
            }
        }
    }
}
extension CollectionViewTableViewCell: MedalImageRequestFetchCoordinator {

    func fetchMedalImage(_ presenter: MedalImagePresenter, medal: MedalModel) {
        medalImageManager.fetchMedalImage(medal) { (medal, image) in
            if let image = image {
                DispatchQueue.main.async(execute: {
                    presenter.displayMedalImage(medal, image: image)
                })
            }
        }
    }
}

extension CollectionViewTableViewCell: UIScrollViewDelegate {

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
