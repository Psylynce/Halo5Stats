//
//  GamertagView.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation
import UIKit

class GamertagView: UIView {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var gamertagLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
        containerView.backgroundColor = UIColor.clear
        gamertagLabel.textColor = UIColor.white
        gamertagLabel.font = UIFont.kelson(.Regular, size: 24)
        gamertagLabel.adjustsFontSizeToFitWidth = true
        gamertagLabel.minimumScaleFactor = 0.5
    }

    func update(withSpartan spartan: Spartan) {
        guard let emblemUrlString = spartan.emblemImageUrl, let gamertag = spartan.displayGamertag, let url = URL(string: emblemUrlString) else { return }

        imageView.image(forUrl: url)
        gamertagLabel.text = gamertag
    }
}
