//
//  NavigationHelper.swift
//  Travelogue
//
//  Created by kent daniel on 2/5/2023.
//

import Foundation
import UIKit

class NavigationHelper {
    
    static func navigateToSignUp(from viewController: UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let signUpViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else {
            return
        }
        
        viewController.navigationController?.pushViewController(signUpViewController, animated: true)
    }
    
    static func navigateToHomeController(from viewController: UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeTabbarViewController else {
            return
        }
        homeVC.navigationItem.hidesBackButton=true
        viewController.navigationController?.pushViewController(homeVC, animated: true)
    }
    
}
