//
//  ItineraryTableViewCell.swift
//  Travelogue
//
//  Created by kent daniel on 8/6/2023.
//

import UIKit

class ItineraryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itineraryLocation: UILabel!
    @IBOutlet weak var itineraryDesc: UILabel!
    @IBOutlet weak var itineraryName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
