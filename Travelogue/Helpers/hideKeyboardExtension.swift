//
//  hideKeyboardExtension.swift
//  Travelogue
//
//  Created by kent daniel on 27/5/2023.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedOutside() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}
