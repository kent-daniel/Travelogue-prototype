//
//  TripEditViewController.swift
//  Travelogue
//
//  Created by kent daniel on 3/5/2023.
//

import UIKit

class TripEditViewController: UIViewController {
    
    var currentUser : User?
    
    @IBOutlet weak var MemberListTableView: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBAction func addTrip(_ sender: Any) {
        TripController().createNewTrip(name: nameTextField.text!, admin: self.currentUser!)
        
        NavigationHelper.navigateToTripController(from: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // get current user
        var currentUserId = AuthController().getCurrentUser()?.uid
        UserController().getUserByID(id: currentUserId!) { user, err in
            if let user = user {
                self.currentUser = user
            } else {
                print(err?.localizedDescription)
            }
        }
        
        // fetch all members
        
        
        // Do any additional setup after loading the view.
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
