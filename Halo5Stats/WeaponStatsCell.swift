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
    @IBOutlet var headshotsLabel: UILabel!

    var weapon: WeaponModel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupAppearance()
    }

    private func setupAppearance() {
        
    }

    func configure(cachedImage: UIImage?) {
        weaponNameLabel.text = weapon.name
        killsLabel.text = "\(weapon.kills)"
        headshotsLabel.text = "\(weapon.headshots)"
        weaponImageView.image = cachedImage
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
