//
//  NavigationHelper.swift
//  Travelogue
//
//  Created by kent daniel on 2/5/2023.
//

import Foundation
import UIKit

class NavigationHelper {
    
  
    
    static func navigateToPostController(from viewController: UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let postVC = storyboard.instantiateViewController(withIdentifier: "CreatePostViewController") as? CreatePostViewController else {
            return
        }
        postVC.navigationItem.hidesBackButton=true
        let navController = UINavigationController(rootViewController: postVC)
        navController.title = "Create a new post"
        postVC.navigationItem.hidesBackButton=true
        viewController.present(navController, animated: true, completion: nil)
        
    }
    
}
