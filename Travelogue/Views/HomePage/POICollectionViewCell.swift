//
//  POICollectionViewCell.swift
//  Travelogue
//
//  Created by kent daniel on 5/6/2023.
//

import UIKit

class POICollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var POIcontainer: UIView!
    @IBOutlet weak var placeType: UILabel!
    @IBOutlet weak var placename: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        POIcontainer.applyBorderRadius(radius: 20).applyShadow()
    }

}
