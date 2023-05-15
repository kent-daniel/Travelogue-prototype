//
//  TripDetailsViewController.swift
//  Travelogue
//
//  Created by kent daniel on 3/5/2023.
//

import UIKit

class TripDetailsViewController: UIViewController {
    @IBOutlet weak var editButton: UIBarButtonItem!
    var trip:Trip?
    var currentUser:User?
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.currentUser = appDelegate?.currentUser
        // set the title of the view controller to the trip name
        self.title = trip?.name
        
        print(trip?.posts)
        UserController().getDocumentReference(for: currentUser!) { currentUserRef in
            guard let currentUserRef = currentUserRef else {
                // handle the case where currentUserRef is nil
                return
            }

            print(currentUserRef , self.trip?.admin)
            if currentUserRef == self.trip?.admin {

                self.editButton.isEnabled = true
            } else {
                self.editButton.isEnabled = false
            }
        }
//
//        }
        
        
        // get all trips
        
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
