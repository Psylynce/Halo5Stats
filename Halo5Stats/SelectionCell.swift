//
//  SelectionCell.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class SelectionCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()

        textLabel?.font = UIFont.kelson(.Regular, size: 16)
        textLabel?.textColor = UIColor(haloColor: .WhiteSmoke)

        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
    }
}
