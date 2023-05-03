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
    
    
    // ISSUE : tightly coupled with user , change return type as trip , more params for more deets
    func createNewTrip(name: String, admin: User?) -> Trip? {
        let trip = Trip()
        trip.name = name
        trip.members = []
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
            
            return trip
            
        } catch {
            print("Failed to create trip: \(error.localizedDescription)")
            return nil
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
    //    func updateTripMembers(members: [User], trip: Trip) {
    //        guard let tripRef = getDocumentReference(for: trip) else {
    //
    //            return
    //        }
    //
    //        let userRef = for user in members{
    //            UserController().getDocumentReference(for: user)
    //        }
    //
    //        tripRef.updateData(["members": FieldValue.arrayUnion([userRef])]) { error in
    //            if let error = error {
    //                // Handle the error
    //                print("Error adding member to trip: \(error.localizedDescription)")
    //            } else {
    //                print("Member added to trip successfully")
    //            }
    //        }
    //    }
    func updateTripMembers(members: [User], trip: Trip) {
        guard let tripRef = getDocumentReference(for: trip) else {
            return
        }
        
        var userRefs = [DocumentReference]()
        
        for member in members {
            guard let memberRef = UserController().getDocumentReference(for: member) else {
                continue
            }
            
            userRefs.append(memberRef)
            // Add the trip to the member's list of trips
            UserController().addTripToUser(user: member, newTrip: trip)
            
            
            tripRef.updateData(["members": FieldValue.arrayUnion(userRefs)]) { error in
                if let error = error {
                    print("Error adding members to trip: \(error.localizedDescription)")
                } else {
                    print("Members added to trip successfully")
                }
            }
        }
        
        
        func deleteTrip(trip:Trip , user:User){
            
        }
        
        
        
        
        
    }
}
