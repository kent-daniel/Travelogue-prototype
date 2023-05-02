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
    var tripCollectionRef : CollectionReference?
    
    override init() {
        database = Firestore.firestore()
        tripCollectionRef = database.collection("trips")
        super.init()
    }
    
    
    func getCurrentUserTrips(completion: @escaping ([Trip]?) -> Void) {
        var tripRefs: [DocumentReference]?
        let currentUser = AuthController().getCurrentUser()
        UserController().getUserByID(id: currentUser!.uid) { user, error in
            if let user = user {
                tripRefs = user.trips
                var trips: [Trip] = []
                let group = DispatchGroup()
                for tripRef in tripRefs ?? [] {
                    group.enter()
                    tripRef.getDocument { document, error in
                        if let document = document, document.exists {
                            let trip = try? document.data(as: Trip.self)
                            if let trip = trip {
                                trips.append(trip)
                            }
                        }
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                    completion(trips)
                }
            } else {
                print("Error retrieving user: \(error?.localizedDescription ?? "")")
                completion(nil)
            }
        }
    }
    
    func createNewTrip(name: String, admin: User?) {
        let trip = Trip()
        trip.name = name
        
        // assign trip creator as admin
        if let admin = admin {
            trip.admin = Firestore.firestore().collection("users").document(admin.id!)
        }
        do {
            // add to trip collection
            if let tripRef = try tripCollectionRef?.addDocument(from: trip) {
                trip.id = tripRef.documentID
            }
            // add trip to user
            UserController().addTripToUser(user: admin!, newTrip: trip)
            
            
        } catch {
            print("Failed to create trip: \(error.localizedDescription)")
        }
    }
    
    // TEMPORARY
    func getDocumentReference(for trip: Trip) -> DocumentReference? {
        if let tripID = trip.id {
            return Firestore.firestore().collection("trips").document(tripID)
        } else {
            return nil
        }
    }
    func addMemberToTrip(user:User , tripName:String){
        // get reference based on email
        // get trip reference based on trip name
        // add reference to members array
        // add trip reference to User.trips
    }
    
    func deleteTrip(trip:Trip , user:User){
        // get user reference based on name
        // check if reference exist in trip.admin
        // remove trip from database
        // remove all trips from user arrays
    }
    
    
    
    
    
}
