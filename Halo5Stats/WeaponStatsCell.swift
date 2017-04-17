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

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.horizontalGradient(weapon.type.color, endColor: .blueCharcoal)
    }

    fileprivate func setupAppearance() {
        weaponNameLabel.textColor = .whiteSmoke
        weaponNameLabel.font = UIFont.kelson(.Bold, size: 32)

        headerLabels.forEach {
            $0.textColor = .curiousBlue
            $0.font = UIFont.kelson(.Light, size: 14)
        }

        killsLabel.textColor = .whiteSmoke
        killsLabel.font = UIFont.kelson(.Regular, size: 14)

        accuracyLabel.textColor = .whiteSmoke
        accuracyLabel.font = UIFont.kelson(.Regular, size: 14)

        backgroundColor = UIColor.clear
    }

    func configure(_ cachedImage: UIImage?, isEven: Bool) {
        weaponNameLabel.text = weapon.name
        killsLabel.text = "\(weapon.kills)"
        accuracyLabel.text = "\(weapon.accuracy)%"
        weaponImageView.image = cachedImage

        let selectionView = UIView()
        selectionView.backgroundColor = weapon.type.color.darker()
        selectedBackgroundView = selectionView
    }
}

extension WeaponStatsCell: ImagePresenter {
    func displayImage(_ model: CacheableImageModel, image: UIImage) {
        if model.cacheIdentifier == weapon.cacheIdentifier {
            weaponImageView.image = image
        }
    }

    func initiateImageRequest(_ coordinator: ImageRequestFetchCoordinator) {
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
