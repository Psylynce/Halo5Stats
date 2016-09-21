//
//  CSRAndSRCell.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class CSRAndSRCell: UITableViewCell {

    @IBOutlet var highestCSRLabel: UILabel!
    @IBOutlet var highestCSRImageView: UIImageView!
    @IBOutlet var srLabel: UILabel!
    @IBOutlet var srValueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupAppearance()
    }

    func configure(csr: CSRModel, spartanRank: Int) {
        highestCSRImageView.image(forUrl: csr.csrImageUrl)
        srValueLabel.text = "\(spartanRank)"
    }

    private func setupAppearance() {
        highestCSRLabel.font = UIFont.kelson(.Regular, size: 16)
        highestCSRLabel.textColor = UIColor(haloColor: .WhiteSmoke)
        highestCSRLabel.text = "Highest CSR"

        srLabel.font = UIFont.kelson(.Regular, size: 16)
        srLabel.textColor = UIColor(haloColor: .WhiteSmoke)
        srLabel.text = "SR"

        srValueLabel.font = UIFont.kelson(.Bold, size: 75)
        srValueLabel.textColor = UIColor(haloColor: .WhiteSmoke)

        backgroundColor = UIColor.clearColor()
        contentView.backgroundColor = UIColor.clearColor()
        selectionStyle = .None
    }
}
