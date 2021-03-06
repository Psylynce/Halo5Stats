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
    @IBOutlet var csrRankLabel: UILabel!
    @IBOutlet var srLabel: UILabel!
    @IBOutlet var srValueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupAppearance()
    }

    func configure(_ csr: CSRModel, spartanRank: Int) {
        highestCSRImageView.image(forUrl: csr.csrImageUrl)
        srValueLabel.text = "\(spartanRank)"

        let correctType = csr.type.rawValue.capitalized
        switch csr.type {
        case .bronze, .silver, .gold, .platinum, .diamond:
            csrRankLabel.text = "\(correctType) \(csr.tier)"
        case .onyx:
            csrRankLabel.text = "\(correctType) \(csr.csr)"
        case .champion:
            if let rank = csr.rank {
                csrRankLabel.text = "\(correctType) \(rank)"
            } else {
                csrRankLabel.text = correctType
            }
        default:
            csrRankLabel.text = nil
        }
    }

    fileprivate func setupAppearance() {
        highestCSRLabel.font = UIFont.kelson(.Regular, size: 16)
        highestCSRLabel.textColor = .whiteSmoke
        highestCSRLabel.text = "Highest CSR"

        csrRankLabel.font = UIFont.kelson(.Light, size: 16)
        csrRankLabel.textColor = .whiteSmoke

        srLabel.font = UIFont.kelson(.Regular, size: 16)
        srLabel.textColor = .whiteSmoke
        srLabel.text = "SR"

        srValueLabel.font = UIFont.kelson(.Bold, size: 75)
        srValueLabel.textColor = .whiteSmoke

        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        selectionStyle = .none
    }
}
