//
//  TripController.swift
//  Travelogue
//
//  Created by kent daniel on 27/4/2023.
//

import UIKit

class TripController: NSObject {
    // move to trips controller
    func getAllTrips(){
        // move to trips controller
        
        var currentUser = AuthController().getCurrentUser()
        var user = UserController().getUserByID(id: currentUser!.uid, completion: { (user, error) in
            
            if let user = user {
                print("User retrieved: \(user)")
            } else {
                print("User not found")
            }
        })
        print(user)
    }
}
