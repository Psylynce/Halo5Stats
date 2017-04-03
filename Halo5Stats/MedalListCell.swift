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
    let placeholder = UIImage(named: "Medal")?.withRenderingMode(.alwaysTemplate)

    override func awakeFromNib() {
        super.awakeFromNib()

        medalCountLabel.font = UIFont.kelson(.Regular, size: 14)
        medalCountLabel.textColor = .whiteSmoke

        medalImageView.image = placeholder
        medalImageView.tintColor = .whiteSmoke
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        medalImageView.image = placeholder
    }

    func configure(_ cachedImage: UIImage?) {
        medalImageView.image = cachedImage
        medalCountLabel.text = "x\(medal.count)"
    }
}

extension MedalListCell: MedalImagePresenter {

    func initiateMedalImageRequest(_ coordinator: MedalImageRequestFetchCoordinator) {
        coordinator.fetchMedalImage(self, medal: medal)
    }

    func displayMedalImage(_ medal: MedalModel, image: UIImage) {
        if medal.cacheIdentifier == self.medal.cacheIdentifier {
            medalImageView.image = image
        }
    }
}
