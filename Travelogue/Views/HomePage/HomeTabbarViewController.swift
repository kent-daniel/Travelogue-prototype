//import UIKit

import UIKit


class HomeTabbarViewController : UITabBarController, UITabBarControllerDelegate{
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        
        
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
