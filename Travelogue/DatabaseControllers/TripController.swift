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
    var TRIP_REF = "trips"
    var MEMBER_REF = "members"
    var POST_REF = "posts"
    var ITINERARY_REF = "itineraries"
    override init() {
        database = Firestore.firestore()
        tripCollectionRef = database.collection(TRIP_REF)
        super.init()
    }
    
    
    
    // MARK: get user trips
    func getUserTrips(user: User, completion: @escaping ([Trip]?) -> Void) {
        var tripRefs: [DocumentReference]?
        tripRefs = user.trips
        var trips: [Trip] = []
        let group = DispatchGroup()

        for tripRef in tripRefs ?? [] {
            group.enter()
            tripRef.getDocument { document, error in
                if let document = document, document.exists {
                    let trip = try? document.data(as: Trip.self)
                    if let trip = trip {
                        self.getAllTripPosts(for: trip) { posts, error in
                            trip.posts = posts
                            self.getAllTripItineraries(for: trip) { itineraries, error in
                                trip.itineraries = itineraries!
                            }
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
    }

    enum Mode {
            case edit
            case create
        }
    
    //MARK: create or update trip
    func createOrUpdateTrip(name: String, desc:String , date:Date , locationName: String, countryCode:String ,  admin: DocumentReference, members:[DocumentReference]?=[] ,itineraries:[Itinerary]?=[] , posts:[Post]?=[], mode:Mode , completion: @escaping (Trip?) -> Void) {
        let trip = Trip()
        trip.name = name
        trip.members = members
        trip.admin = admin
        trip.date = date
        trip.tripDesc = desc
        trip.members = members
        trip.locationName = locationName
        trip.countryCode = countryCode
        
        do {
            // Add trip to the "trips" collection
            if mode == .create{
                let tripRef = try tripCollectionRef!.addDocument(from: trip)
                trip.id = tripRef.documentID
                updateItinerariesInTrip(itineraries: itineraries ?? [], trip: trip)
            }else if mode == .edit{
                let tripRef = try getDocumentReference(for: trip)
                try tripRef?.setData(from: trip)
                updateItinerariesInTrip(itineraries: itineraries ?? [], trip: trip)
            }
            
            completion(trip)
            
        } catch {
            print("Failed to create trip: \(error.localizedDescription)")
            completion(nil)
        }
    }

    
    // MARK: get doc reference
    func getDocumentReference(for trip: Trip) -> DocumentReference? {
        if let tripID = trip.id {
            return tripCollectionRef!.document(tripID)
        } else {
            return nil
        }
    }
  
    // MARK: Update trip members
    func updateTripMembers(members: [DocumentReference], trip: Trip) {
        guard let tripId = trip.id else {
            print("Trip ID is missing.")
            return
        }
        tripCollectionRef!.document(tripId).updateData([
            MEMBER_REF: members
        ]) { error in
            if let error = error {
                print("Error updating trip document: \(error.localizedDescription)")
            } else {
                print("Trip document updated successfully!")
            }
        }
    }

    // MARK: Remove member from trip
    func removeMemberFromTrip(member: DocumentReference, trip: Trip) {
        guard let tripId = trip.id else {
            print("Trip ID is missing.")
            return
        }
        tripCollectionRef!.document(tripId).updateData([
            MEMBER_REF: FieldValue.arrayRemove([member])
        ]) { error in
            if let error = error {
                print("Error updating trip document: \(error.localizedDescription)")
            } else {
                print("Trip document updated successfully!")
            }
        }
    }
    
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

    // MARK: add post to trip
    func addPostToTrip(post: Post?, trip: Trip, by currentUser: User) {
        do {
            let tripRef = tripCollectionRef!.document(trip.id!)
            let postsRef = tripRef.collection(POST_REF)
            try postsRef.addDocument(from: post)
        } catch let error {
            print("Error adding post: \(error.localizedDescription)")
        }
        
    }
    
    func getAllTripItineraries(for trip:Trip , completion: @escaping ([Itinerary]? , Error?)-> Void){
        let db = Firestore.firestore()
        let tripRef = tripCollectionRef!.document(trip.id!)
        let itinerariesRef = tripRef.collection("itineraries")
        
        itinerariesRef.getDocuments { snapshot, error in
            if let error = error {
                completion(nil, error)
            } else if let snapshot = snapshot {
                var itineraryList: [Itinerary] = []
                for document in snapshot.documents {
                    do {
                        let itinerary = try document.data(as: Itinerary.self)
                        
                            itineraryList.append(itinerary)
                        
                    } catch let error {
                        print("Error decoding itinerary: \(error.localizedDescription)")
                    }
                }
                completion(itineraryList, nil)
            }
        }
        
    }
    
    // get all trip posts
    func getAllTripPosts(for trip: Trip, completion: @escaping ([Post]?, Error?) -> Void) {
        
        let tripRef = tripCollectionRef!.document(trip.id!)
        let postsRef = tripRef.collection(POST_REF)

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






        
        
        
        

