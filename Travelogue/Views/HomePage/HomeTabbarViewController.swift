//
//  HomeViewController.swift
//  Travelogue
//
//  Created by kent daniel on 11/5/2023.
//

import UIKit

class HomeTabbarViewController: UITabBarController , UITabBarControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
            if viewController is CreatePostViewController {
                let modalVC = CreatePostViewController()
                modalVC.modalPresentationStyle = .overFullScreen
                self.present(modalVC, animated: true, completion: nil)
                return false // prevent the selected view controller from being shown
            }
            return true // allow the selected view controller to be shown
        }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
