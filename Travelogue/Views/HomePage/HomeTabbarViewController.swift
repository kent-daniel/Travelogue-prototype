//import UIKit

import UIKit
//////
//////  HomeViewController.swift
//////  Travelogue
//////
//////  Created by kent daniel on 11/5/2023.
//////
////
////import UIKit
////
////class HomeTabbarViewController: UITabBarController , UITabBarControllerDelegate{
////
////    override func viewDidLoad() {
////        super.viewDidLoad()
//////        self.delegate = self
////        // Do any additional setup after loading the view.
////    }
////
////    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
////            if viewController is CreatePostViewController {
////                let modalVC = CreatePostViewController()
////                modalVC.modalPresentationStyle = .overFullScreen
////                self.present(modalVC, animated: true, completion: nil)
////                return false // prevent the selected view controller from being shown
////            }
////            return true // allow the selected view controller to be shown
////        }
////    /*
////    // MARK: - Navigation
////
////    // In a storyboard-based application, you will often want to do a little preparation before navigation
////    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
////        // Get the new view controller using segue.destination.
////        // Pass the selected object to the new view controller.
////    }
////    */
////
////}
//
//

class HomeTabbarViewController : UITabBarController, UITabBarControllerDelegate{
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the tab bar background color to black
        tabBar.barTintColor = .black
        
        // Set the tab bar item text color to white
        tabBar.tintColor = .white
        
        self.title=""
        
        
    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        return true
    }
    
}

//class HomeTabbarViewController: UITabBarController, UITabBarControllerDelegate {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Set the delegate of the tab bar controller
//        self.delegate = self
//
//        // Create the first view controller
//        let homeVC = SignUpViewController()
//        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
//
//        // Create the second view controller
//        let tripVC = TripTableViewController()
//        tripVC.tabBarItem = UITabBarItem(title: "Trip", image: UIImage(systemName: "magnifyingglass"), tag: 1)
//
//        // Set the view controllers for the tab bar controller
//        self.setViewControllers([homeVC, tripVC], animated: false)
//
//        // Create the plus button
//        let plusButton = UIButton(type: .custom)
//        plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
//        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
//
//        // Add the plus button to the tab bar
//        self.tabBar.addSubview(plusButton)
//
//        // Position the plus button
//        let tabBarWidth = self.tabBar.frame.width
//        let buttonWidth = tabBarWidth / 5 // divide by the number of tab bar items + 1 to get the button width
//        plusButton.frame = CGRect(x: 2 * buttonWidth, y: 0, width: buttonWidth, height: self.tabBar.frame.height)
//        plusButton.tintColor = .systemBlue
//    }
//
//
//
//    @objc func plusButtonTapped() {
//        let modalVC = TripTableViewController()
//        modalVC.modalPresentationStyle = .overFullScreen
//        self.present(modalVC, animated: true, completion: nil)
//    }
//
//}
