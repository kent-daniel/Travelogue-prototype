//
//  MemberTableViewCell.swift
//  Travelogue
//
//  Created by kent daniel on 3/6/2023.
//

import UIKit

class MemberTableViewCell: UITableViewCell {
    @IBOutlet weak var MemberName: UILabel!
    @IBOutlet weak var memberProfileImage: UIImageView!
    @IBOutlet weak var memberEmail: UILabel!
    
    private var activityIndicator: UIActivityIndicatorView!
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        memberProfileImage.applyBorderRadius(radius: memberProfileImage.frame.width/2)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
