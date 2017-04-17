//
//  SpartanCell.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

protocol SpartanCellDelegate: class {
    func compareButtonTapped(_ spartan: SpartanModel)
    func favoriteButtonTapped(_ cell: SpartanCell)
}

class SpartanCell: UITableViewCell {

    @IBOutlet weak var emblemImageView: UIImageView!
    @IBOutlet weak var gamertagLabel: UILabel!
    @IBOutlet weak var compareButton: SelectableButton!
    @IBOutlet weak var favoriteButton: UIButton!

    var cellModel: SpartanCellModel! {
        didSet {
            configure(cellModel.spartan)

            cellModel.isComparing.bindAndFire { [weak self] (isComparing) in
                self?.compareButton.isSelected = isComparing
            }

            cellModel.isFavorite.bindAndFire { [weak self] (isFavorite) in
                let image = isFavorite ? UIImage(named: "Star_Filled") : UIImage(named: "Star")
                self?.favoriteButton.setImage(image?.withRenderingMode(.alwaysTemplate), for: UIControlState())
                self?.favoriteButton.imageView?.tintColor = isFavorite ? .whiteSmoke : UIColor.whiteSmoke.withAlphaComponent(0.4)
            }
        }
    }
    weak var delegate: SpartanCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        gamertagLabel.font = UIFont.kelson(.Regular, size: 18)
        gamertagLabel.textColor = .whiteSmoke

        compareButton.setTitle("COMPARE", for: UIControlState())

        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        emblemImageView.image = nil
        accessoryType = .disclosureIndicator
        favoriteButton.isHidden = false
    }

    fileprivate func configure(_ spartan: SpartanModel) {
        gamertagLabel.text = spartan.displayGamertag
        emblemImageView.image(forUrl: spartan.emblemUrl)
    }

    @IBAction func compareButtonTapped(_ sender: UIButton) {
        cellModel.isComparing.value = !cellModel.isComparing.value
        compareButton.isSelected = cellModel.isComparing.value
        delegate?.compareButtonTapped(cellModel.spartan)
    }

    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        cellModel.isFavorite.value = FavoritesManager.sharedManager.isFavorite(cellModel.spartan.gamertag)
        FavoritesManager.sharedManager.manageSpartan(cellModel.spartan.gamertag)
        delegate?.favoriteButtonTapped(self)
    }
}
