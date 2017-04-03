//
//  SettingsCell.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    @IBOutlet var borderView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        textLabel?.font = UIFont.kelson(.Regular, size: 18)
        textLabel?.textColor = .whiteSmoke

        borderView.backgroundColor = .whiteSmoke

        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
    }
}
