//
//  CustomTextfieldExtension.swift
//  Travelogue
//
//  Created by kent daniel on 28/5/2023.
//

import Foundation
import UIKit

extension UITextField {
    
    // Apply underline style to the text field
    func applyUnderlineStyle() {
        borderStyle = .none
        backgroundColor = .clear
        
        let lineView = UIView()
        lineView.backgroundColor = .systemGray
        lineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(lineView)
        
        NSLayoutConstraint.activate([
            lineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            lineView.bottomAnchor.constraint(equalTo: bottomAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    // Apply dark background style to the text field
    func applyDarkBackgroundStyle() {
        backgroundColor = .darkGray
        textColor = .white
    }
    
    
    
}
