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
    
    static func navigateToTripController(from viewController: UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let tripViewController = storyboard.instantiateViewController(withIdentifier: "TripTableViewController") as? TripTableViewController else {
            return
        }
        tripViewController.navigationItem.hidesBackButton=true
        viewController.navigationController?.pushViewController(tripViewController, animated: true)
    }
    
}
