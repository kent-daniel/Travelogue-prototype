//
//  CustomButtonExtension.swift
//  Travelogue
//
//  Created by kent daniel on 29/5/2023.
//

import Foundation
import UIKit
extension UIButton {
    
    // Apply primary CTA style to the button
    func applyPrimaryCTAStyle() {
        
        layer.cornerRadius = 8
        titleLabel?.font = UIFont.boldSystemFont(ofSize: titleLabel?.font.pointSize ?? 17)
    }
    
    
    
    // Apply text style to the button
    func applyTextStyle() {
        setTitleColor(.black, for: .normal)
        backgroundColor = .clear
        layer.cornerRadius = 0
        layer.borderWidth = 0
    }
    
    // Apply ghost style to the button
    func applyGhostStyle() {
        setTitleColor(.systemBlue, for: .normal)
        backgroundColor = .clear
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    // Add more styling options as needed
    
}

