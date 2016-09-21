//
//  SpartanCell.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

protocol SpartanCellDelegate: class {
    func compareButtonTapped(spartan: SpartanModel)
    func favoriteButtonTapped(cell: SpartanCell)
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
                self?.compareButton.selected = isComparing
            }

            cellModel.isFavorite.bindAndFire { [weak self] (isFavorite) in
                let image = isFavorite ? UIImage(named: "Star_Filled") : UIImage(named: "Star")
                self?.favoriteButton.setImage(image?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
                self?.favoriteButton.imageView?.tintColor = isFavorite ? UIColor(haloColor: .WhiteSmoke) : UIColor(haloColor: .WhiteSmoke).colorWithAlphaComponent(0.4)
            }
        }
    }
    weak var delegate: SpartanCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        gamertagLabel.font = UIFont.kelson(.Regular, size: 18)
        gamertagLabel.textColor = UIColor(haloColor: .WhiteSmoke)

        compareButton.setTitle("COMPARE", forState: .Normal)

        contentView.backgroundColor = UIColor.clearColor()
        backgroundColor = UIColor.clearColor()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        emblemImageView.image = nil
        accessoryType = .DisclosureIndicator
        favoriteButton.hidden = false
    }

    private func configure(spartan: SpartanModel) {
        gamertagLabel.text = spartan.displayGamertag
        emblemImageView.image(forUrl: spartan.emblemUrl)
    }

    @IBAction func compareButtonTapped(sender: UIButton) {
        cellModel.isComparing.value = !cellModel.isComparing.value
        compareButton.selected = cellModel.isComparing.value
        delegate?.compareButtonTapped(cellModel.spartan)
    }

    @IBAction func favoriteButtonTapped(sender: UIButton) {
        cellModel.isFavorite.value = FavoritesManager.sharedManager.isFavorite(cellModel.spartan.gamertag)
        FavoritesManager.sharedManager.manageSpartan(cellModel.spartan.gamertag)
        delegate?.favoriteButtonTapped(self)
    }
}
