//
//  TripCell.swift
//  Travelogue
//
//  Created by kent daniel on 31/5/2023.
//

import UIKit

class TripCell: UITableViewCell {
    @IBOutlet weak var tripName: UILabel!
    @IBOutlet weak var tripDate: UILabel!
    @IBOutlet weak var tripMembersCount: UILabel!
    @IBOutlet weak var adminName: UILabel!
    @IBOutlet weak var adminProfile: UIImageView!
    @IBOutlet weak var tripDesc: UILabel!
    @IBOutlet weak var locationName:UILabel!
    
    @IBOutlet weak var tripContainer: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tripContainer.applyBorderRadius(radius: 30).applyBorder(color: .systemGray )
        adminProfile.applyBorderRadius(radius: adminProfile.frame.width/2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
