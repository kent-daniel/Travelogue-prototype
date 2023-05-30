//
//  CreateTripSetupUI.swift
//  Travelogue
//
//  Created by kent daniel on 10/5/2023.
//

import UIKit


// UI Setup
extension CreateTripViewController{
    // UI set up
    
    func tableViewSetup() {
        membersTable.layer.cornerRadius = 8
        membersTable.layer.masksToBounds = true
        membersTable.isEditing = true
        membersTable.dataSource = self
        membersTable.delegate = self
        membersTable.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        membersTable.register(MemberTableViewCell.self, forCellReuseIdentifier: "membersCell")
        membersTable.heightAnchor.constraint(equalToConstant: 0).isActive = true // Set initial height to 0
    }
   
}
