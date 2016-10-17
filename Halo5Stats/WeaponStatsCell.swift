//
//  WeaponStatsCell.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class WeaponStatsCell: UITableViewCell {

    @IBOutlet var weaponImageView: UIImageView!
    @IBOutlet var weaponNameLabel: UILabel!
    @IBOutlet var headerLabels: [UILabel]!
    @IBOutlet var killsLabel: UILabel!
    @IBOutlet var accuracyLabel: UILabel!
    @IBOutlet var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var imageViewBottomConstraint: NSLayoutConstraint!

    var imageViewTopInitial: CGFloat!
    var imageViewBottomInitial: CGFloat!

    var weapon: WeaponModel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupInitialPosition()
        setupAppearance()
    }

    private func setupAppearance() {
        weaponNameLabel.textColor = UIColor(haloColor: .WhiteSmoke)
        weaponNameLabel.font = UIFont.kelson(.Bold, size: 32)

        headerLabels.forEach {
            $0.textColor = UIColor(haloColor: .CuriousBlue)
            $0.font = UIFont.kelson(.Light, size: 14)
        }

        killsLabel.textColor = UIColor(haloColor: .WhiteSmoke)
        killsLabel.font = UIFont.kelson(.Regular, size: 14)

        accuracyLabel.textColor = UIColor(haloColor: .WhiteSmoke)
        accuracyLabel.font = UIFont.kelson(.Regular, size: 14)

        backgroundColor = UIColor.clearColor()
    }

    func configure(cachedImage: UIImage?, isEven: Bool) {
        weaponNameLabel.text = weapon.name
        killsLabel.text = "\(weapon.kills)"
        accuracyLabel.text = "\(weapon.accuracy)%"
        weaponImageView.image = cachedImage

        contentView.backgroundColor = isEven ? UIColor(haloColor: .Cinder) : UIColor(haloColor: .Elephant)
        let selectionView = UIView()
        selectionView.backgroundColor = contentView.backgroundColor?.lighter(0.15)
        selectedBackgroundView = selectionView
    }
}

extension WeaponStatsCell: ImagePresenter {
    func displayImage(model: CacheableImageModel, image: UIImage) {
        if model.cacheIdentifier == weapon.cacheIdentifier {
            weaponImageView.image = image
        }
    }

    func initiateImageRequest(coordinator: ImageRequestFetchCoordinator) {
        coordinator.fetchImage(self, model: weapon)
    }
}

extension WeaponStatsCell: ParallaxScrollingCell {

    var imageTopConstraint: NSLayoutConstraint {
        return imageViewTopConstraint
    }

    var imageBottomConstraint: NSLayoutConstraint {
        return imageViewBottomConstraint
    }

    var imageTopInitial: CGFloat {
        return imageViewTopInitial
    }

    var imageBottomInitial: CGFloat {
        return imageViewBottomInitial
    }

    func setupInitialPosition() {
        imageViewBottomConstraint.constant -= 2 * parallaxFactor
        imageViewTopInitial = imageViewTopConstraint.constant
        imageViewBottomInitial = imageViewBottomConstraint.constant
    }
}
