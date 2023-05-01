//
//  TripController.swift
//  Travelogue
//
//  Created by kent daniel on 27/4/2023.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class TripController: NSObject {
    var database: Firestore
    var tripRef : CollectionReference?
    // move to trips controller
    func getCurrentUserTrips(){
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
    
    func createTrip(){
        
    }
    
    override init() {
        database = Firestore.firestore()
        tripRef = database.collection("trips")
        super.init()
    }
}
