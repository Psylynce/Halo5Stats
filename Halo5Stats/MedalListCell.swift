//
//  MedalListCell.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class MedalListCell: UICollectionViewCell {

    @IBOutlet var medalImageView: UIImageView!
    @IBOutlet var medalCountLabel: UILabel!

    var medal: MedalModel!
    let placeholder = UIImage(named: "Medal")?.imageWithRenderingMode(.AlwaysTemplate)

    override func awakeFromNib() {
        super.awakeFromNib()

        medalCountLabel.font = UIFont.kelson(.Regular, size: 14)
        medalCountLabel.textColor = UIColor(haloColor: .WhiteSmoke)

        medalImageView.image = placeholder
        medalImageView.tintColor = UIColor(haloColor: .WhiteSmoke)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        medalImageView.image = placeholder
    }

    func configure(cachedImage: UIImage?) {
        medalImageView.image = cachedImage
        medalCountLabel.text = "x\(medal.count)"
    }
}

extension MedalListCell: MedalImagePresenter {

    func initiateMedalImageRequest(coordinator: MedalImageRequestFetchCoordinator) {
        coordinator.fetchMedalImage(self, medal: medal)
    }

    func displayMedalImage(medal: MedalModel, image: UIImage) {
        if medal.cacheIdentifier == self.medal.cacheIdentifier {
            medalImageView.image = image
        }
    }
}
