//
//  PostTableViewCell.swift
//  Travelogue
//
//  Created by kent daniel on 9/6/2023.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var DateTime: UILabel!
    @IBOutlet weak var postDesc: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImage.applyBorderRadius(radius: 28)
        postImage.applyBorderRadius(radius: 40)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
