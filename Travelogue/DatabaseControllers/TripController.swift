//
//  TripController.swift
//  Travelogue
//
//  Created by kent daniel on 27/4/2023.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import CoreLocation

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
                                self.getAllTripPosts(for: trip){ posts,error in
                                    //print(posts)
                                    trip.posts = posts!
                                    
                                }
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
  
    func updateTripMembers(members: [User], trip: Trip) {
        guard let tripRef = getDocumentReference(for: trip) else {
            return
        }
        
        var userRefs = [DocumentReference]()
        
        for member in members {
            UserController().getDocumentReference(for: member) { (memberRef) in
                
                
                if let memberRef = memberRef {
                    userRefs.append(memberRef)
                    
                    // Add the trip to the member's list of trips
                    UserController().addTripToUser(user: member, newTrip: trip)
                }
            }
            
        }
            
            
            tripRef.updateData(["members": FieldValue.arrayUnion(userRefs)]) { error in
                if let error = error {
                    print("Error adding members to trip: \(error.localizedDescription)")
                } else {
                    print("Members added to trip successfully")
                }
            }
        }
    
        
//        func deleteTrip(trip:Trip , user:User){
//
//        }
    
    func updateItinerariesInTrip(itineraries: [Itinerary], trip: Trip) {
        guard let tripRef = getDocumentReference(for: trip) else {
            return
        }
        
        // Create a subcollection reference for itineraries under the trip
        let itinerariesCollectionRef = tripRef.collection("itineraries")
        
        // Delete existing itineraries in the subcollection
        itinerariesCollectionRef.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error retrieving existing itineraries: \(error.localizedDescription)")
                return
            }
            
            // Delete each existing itinerary document
            snapshot?.documents.forEach { document in
                itinerariesCollectionRef.document(document.documentID).delete()
            }
            
            // Add the new itineraries to the subcollection
            for itinerary in itineraries {
                do {
                    let itineraryDocRef = try itinerariesCollectionRef.addDocument(from: itinerary)
                    
                    // Update the itinerary's ID with the document ID assigned by Firestore
                    itinerary.id = itineraryDocRef.documentID
                } catch {
                    print("Failed to add itinerary to trip: \(error.localizedDescription)")
                }
            }
            
            print("Itineraries overwritten successfully")
        }
    }

    
    func addPostToTrip(imageURL: String?, trip: Trip, by currentUser: User) {
        UserController().getDocumentReference(for: currentUser) { userRef in
            guard let userRef = userRef else {
                print("Error getting user reference")
                return
            }
            var newPost = Post()
            newPost.poster = userRef
            newPost.dateTime = Date()
            newPost.url = imageURL!

                do {
                    let db = Firestore.firestore()
                    let tripRef = db.collection("trips").document(trip.id!)
                    let postsRef = tripRef.collection("posts")
                    try postsRef.addDocument(from: newPost)
                } catch let error {
                    print("Error adding post: \(error.localizedDescription)")
                }
        }
    }
    
    func getAllTripPosts(for trip: Trip, completion: @escaping ([Post]?, Error?) -> Void) {
        let db = Firestore.firestore()
        let tripRef = db.collection("trips").document(trip.id!)
        let postsRef = tripRef.collection("posts")

        postsRef.getDocuments { snapshot, error in
            if let error = error {
                completion(nil, error)
            } else if let snapshot = snapshot {
                var posts: [Post] = []
                for document in snapshot.documents {
                    do {
                        let post = try document.data(as: Post.self)
                        
                            posts.append(post)
                        
                    } catch let error {
                        print("Error decoding post: \(error.localizedDescription)")
                    }
                }
                completion(posts, nil)
            }
        }
    }





        
        
        
        
}


//class TripController: CLLocationManagerDelegate {
//
//    var locationManager: CLLocationManager?
//
//    func getLocation(completion: @escaping (CLLocation?, Error?) -> Void) {
//        locationManager = CLLocationManager()
//        locationManager?.delegate = self
//        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager?.requestWhenInUseAuthorization()
//        locationManager?.requestLocation()
//
//        // Store the completion handler so it can be called later
//        self.completionHandler = completion
//    }
//
//    // CLLocationManagerDelegate methods
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else {
//            return
//        }
//        // Call the completion handler with the location and no error
//        completionHandler?(location, nil)
//        completionHandler = nil // clear the completion handler
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        // Call the completion handler with no location and the error
//        completionHandler?(nil, error)
//        completionHandler = nil // clear the completion handler
//    }
//
//    private var completionHandler: ((CLLocation?, Error?) -> Void)?
//
//}


