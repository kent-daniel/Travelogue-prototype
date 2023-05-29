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
    func applyUnderlineStyle() -> Self {
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
        return self
    }
    
    // Apply dark background style to the text field
    func applyDarkBackgroundStyle() {
        backgroundColor = .darkGray
        textColor = .white
    }
    
    // Set an icon on the left or right side of the text field
    func setIcon(_ image: UIImage?, side: IconSide) {
        let iconImageView = UIImageView(image: image)
        iconImageView.contentMode = .center
        
        let padding: CGFloat = 10
        let imageViewWidth: CGFloat = 30
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: imageViewWidth + padding, height: frame.height))
        containerView.addSubview(iconImageView)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: frame.height))
        containerView.addSubview(paddingView)
        
        if side == .left {
            leftView = containerView
            leftViewMode = .always
            iconImageView.frame = CGRect(x: padding, y: 0, width: imageViewWidth, height: frame.height)
        } else {
            rightView = containerView
            rightViewMode = .always
            iconImageView.frame = CGRect(x: 0, y: 0, width: imageViewWidth, height: frame.height)
        }
        
        iconImageView.tintColor = .systemGray
        iconImageView.center = containerView.center
    }

        
        
    
}

// Enum for icon side
extension UITextField {
    enum IconSide {
        case left
        case right
    }
}
