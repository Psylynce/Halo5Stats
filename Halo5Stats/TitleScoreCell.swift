//
//  TitleScoreCell.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class TitleScoreCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!

    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!

    var medal: MedalModel?

    override func awakeFromNib() {
        super.awakeFromNib()

        titleLabel.textColor = UIColor(haloColor: .WhiteSmoke)
        titleLabel.font = UIFont.kelson(.Medium, size: 14.0)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.6
        scoreLabel.textColor = UIColor(haloColor: .WhiteSmoke)
        scoreLabel.font = UIFont.kelson(.Regular, size: 12.0)

        contentView.backgroundColor = UIColor.clearColor()
        backgroundColor = UIColor.clearColor()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = nil
        titleLabel.text = ""
        scoreLabel.text = ""
    }

    func configure(item: DisplayItem, cachedImage: UIImage? = nil) {
        if let title = item.title {
            titleLabel.text = title
        }
        scoreLabel.text = item.number

        if item is MedalModel {
            imageView.contentMode = .ScaleAspectFit
            imageViewHeightConstraint.constant = 35
            imageViewWidthConstraint.constant = 35
            imageView.image = cachedImage
        } else {
            if let url = item.url {
                imageView.image(forUrl: url)
            }
        }
    }
}

extension TitleScoreCell: MedalImagePresenter {

    func initiateMedalImageRequest(coordinator: MedalImageRequestFetchCoordinator) {
        guard let medal = medal else { return }
        coordinator.fetchMedalImage(self, medal: medal)
    }

    func displayMedalImage(medal: MedalModel, image: UIImage) {
        guard let cellMedal = self.medal else { return }

        if medal.cacheIdentifier == cellMedal.cacheIdentifier {
            imageView.image = image
        }
    }
}
