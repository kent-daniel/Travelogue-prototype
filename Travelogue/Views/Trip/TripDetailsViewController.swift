//
//  TripDetailsViewController.swift
//  Travelogue
//
//  Created by kent daniel on 3/5/2023.
//

import UIKit

class TripDetailsViewController: UIViewController {
    @IBOutlet weak var editButton: UIBarButtonItem!
    var trip=Trip()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the title of the view controller to the trip name
        self.title = trip.name
        
        // make sure there is a current user
        guard let userID = AuthController().getCurrentUser()?.uid else {
            // handle the case where there is no current user
            print("No current user found.")
            return
        }
        
        // get the user document for the current user
        UserController().getUserByID(id: userID) { user, error in
            if let error = error {
                // handle the case where there is an error getting the user document
                print("Error getting user document: \(error.localizedDescription)")
                return
            }
            
            guard let user = user else {
                // handle the case where there is no user document for the current user
                print("No user document found for current user.")
                return
            }
            
            // get the document reference for the current user
            guard let currentUserRef = UserController().getDocumentReference(for: user) else {
                // handle the case where there is an error getting the document reference for the current user
                print("Error getting document reference for current user.")
                return
            }
            
            // check if the current user is the admin of the trip
            if currentUserRef == self.trip.admin {
                // enable the edit button if the current user is the admin of the trip
                self.editButton.isEnabled = true
            } else {
                // disable the edit button if the current user is not the admin of the trip
                self.editButton.isEnabled = false
            }
        }
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
