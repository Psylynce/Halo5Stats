//
//  SimpleWeaponCell.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class SimpleWeaponCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var killTitleLabel: UILabel!
    @IBOutlet var headshotTitleLabel: UILabel!
    @IBOutlet var accuracyTitleLabel: UILabel!
    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet var killLabel: UILabel!
    @IBOutlet var headshotLabel: UILabel!
    @IBOutlet var accuracyLabel: UILabel!
    @IBOutlet var statsLabels: [UILabel]!

    var weapon: WeaponModel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupAppearance()
    }

    fileprivate func setupAppearance() {
        titleLabels.forEach {
            $0.textColor = UIColor.curiousBlue.lighter()
            $0.font = UIFont.kelson(.Light, size: 14)
        }

        statsLabels.forEach {
            $0.textColor = .whiteSmoke
            $0.font = UIFont.kelson(.Regular, size: 16)
        }

        killTitleLabel.text = "K"
        headshotTitleLabel.text = "HS"
        accuracyTitleLabel.text = "%"
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        killLabel.text = ""
        headshotLabel.text = ""
        accuracyLabel.text = ""
        imageView.image = weapon.placeholderImage
    }

    func configure(_ item: DisplayItem, cachedImage: UIImage?) {
        imageView.image = cachedImage

        let numberComponents = item.number.components(separatedBy: "_")
        guard numberComponents.count == 3 else { return }

        let kills = numberComponents[0]
        let headshots = numberComponents[1]
        let accuracy = numberComponents[2]

        killLabel.text = kills
        headshotLabel.text = headshots
        accuracyLabel.text = accuracy
    }
}

extension SimpleWeaponCell: ImagePresenter {

    func initiateImageRequest(_ coordinator: ImageRequestFetchCoordinator) {
        coordinator.fetchImage(self, model: weapon)
    }

    func displayImage(_ model: CacheableImageModel, image: UIImage) {
        if model.cacheIdentifier == weapon.cacheIdentifier {
            imageView.image = image
        }
    }
}
