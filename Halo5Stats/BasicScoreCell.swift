//
//  BasicScoreCell.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class BasicScoreCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        label.textColor = UIColor(haloColor: .WhiteSmoke)
        label.font = UIFont.kelson(.Regular, size: 14.0)

        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        label.text = ""
        imageView.image = nil
    }

    func configure(_ item: DisplayItem) {
        if let url = item.url {
            imageView.image(forUrl: url)
        }
        label.text = item.number
    }
}
