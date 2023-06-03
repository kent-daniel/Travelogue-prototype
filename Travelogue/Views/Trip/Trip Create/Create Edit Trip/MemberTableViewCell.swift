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
    
    func showLoadingIndicator() {
        if activityIndicator == nil {
            activityIndicator = UIActivityIndicatorView(style: .medium)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(activityIndicator)
            
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: memberProfileImage.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: memberProfileImage.centerYAnchor)
            ])
            
            memberProfileImage.applyBorderRadius(radius: memberProfileImage.frame.size.width / 2) // Set rounded corners using the extension
        }
        
        activityIndicator.startAnimating()
    }

    
    func hideLoadingIndicator() {
        activityIndicator?.stopAnimating()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
