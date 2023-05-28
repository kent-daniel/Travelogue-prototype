//
//  UserController.swift
//  Travelogue
//
//  Created by kent daniel on 27/4/2023.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class UserController: NSObject {
    var database: Firestore
    var userRef : CollectionReference?
    let USER_COL_NAME = "users"
    override init() {
        database = Firestore.firestore()
        userRef = database.collection(USER_COL_NAME)
        super.init()
    }
    
    func setupUserListener(){
        // TODO
//        userRef?.addSnapshotListener() {
//            (querySnapshot, error) in
//            guard let querySnapshot = querySnapshot else {
//                print("Failed to fetch documents with error: \(String(describing: error))");
//                return
//            }
//            self.parseUserSnapshot(snapshot: QuerySnapshot)
//        }
        
        
    }
    
    
    func getDocumentReference(for user: User, completion: @escaping (DocumentReference?, Error?) -> Void) {
        if let userID = user.id {
            let userRef = Firestore.firestore().collection(USER_COL_NAME).document(userID)
            completion(userRef, nil)
        } else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "User ID is nil"])
            completion(nil, error)
        }
    }


    // MARK: - CREATE USER
    func createUser(id: String, email: String, name: String, trips: [DocumentReference] = []) -> User? {
        let user = User()
        user.id = id
        user.email = email
        user.name = name
        user.trips = trips
        
        let userRef = userRef?.document(id)
        
        do {
            try userRef?.setData(from: user)
            print("User created with ID: \(id)")
            return user
        } catch {
            print("Failed to create user: \(error.localizedDescription)")
            return nil
        }
    }

    
    
    
    func getUserByID(id: String, completion: @escaping (User?, Error?) -> Void) {
        
        // Get a reference to the "users" collection in Firestore
        let usersCollection = Firestore.firestore().collection(USER_COL_NAME)
        
        // Get a reference to the document with the given ID in the "users" collection
        let userDoc = usersCollection.document(id)
        
        // Retrieve the user's data from Firestore
        userDoc.getDocument { (documentSnapshot, error) in
            
            // Handle any errors that occurred while retrieving the user's data
            if let error = error {
                completion(nil, error)
                return
            }
            
            // Check if the user's document exists in the database
            guard let document = documentSnapshot else {
                completion(nil, nil)
                return
            }
            
            // Convert the user's data into a User object
            do {
                let user = try document.data(as: User.self)
                completion(user, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    func searchUsersByEmail(email: String, completion: @escaping ([User]?, Error?) -> Void) {
        
        // Create a query that searches for users with email equal to or containing the given string
        let query = userRef!.whereField("email", isGreaterThanOrEqualTo: email)
            .whereField("email", isLessThanOrEqualTo: email + "\u{f8ff}")
        
        // Execute the query and retrieve the matching documents
        query.getDocuments { (querySnapshot, error) in
            // Handle any errors that occurred while retrieving the documents
            if let error = error {
                completion(nil, error)
                return
            }
            
            // Convert the documents into User objects and add them to the results array
            var results: [User] = []
            for document in querySnapshot!.documents {
                do {
                    let user = try document.data(as: User.self)
                    print(user.email)
                    results.append(user)
                } catch {
                    print("Unable to decode user. Is the user malformed?")
                }
            }
            
            // Call the completion handler with the results array
            completion(results, nil)
        }
    }
    
    func addTripToUser(user:User , newTrip:Trip){
        // get trip reference
        let tripRef = TripController().getDocumentReference(for: newTrip)!
        
        // get user reference
        let userRef = userRef?.document(user.id!)
        
        // "append" trip
        userRef!.updateData([
            "trips": FieldValue.arrayUnion([tripRef])
        ]){ error in
            if let error = error {
                print("Error updating user document: \(error.localizedDescription)")
            } else {
                print("User document updated successfully!")
            }
            
        }
        
//        func parseUserSnapshot(snapshot:QuerySnapshot){
//
//            snapshot.documentChanges.forEach { (change) in
//                var parsedUser: User?
//                do {
//                    parsedUser = try change.document.data(as: User.self)
//                    var docRefs = parsedUser?.trips
//                    docRefs?.forEach({ docRef in
//                        docRef.getDocument { (document, error) in
//                            if let error = error {
//                                print("Error fetching document: \(error)")
//                            } else if let document = document, document.exists {
//                                //                            let data = document.data(as: Trip.self)
//                                // trips
//                                //                            print(data)
//                                // Process the data as needed
//                            } else {
//                                print("Document does not exist")
//                            }
//                        }
//                    })
//
//                } catch {
//                    print("Unable to decode hero. Is the hero malformed?")
//                    return
//                }
//
//            }
            
//        }
    }
}
