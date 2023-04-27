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
    
    override init() {
        database = Firestore.firestore()
        userRef = database.collection("users")
        super.init()
        self.setupUserListener()
    }
    
    func setupUserListener(){ 
        userRef?.addSnapshotListener() {
            (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("Failed to fetch documents with error: \(String(describing: error))");
                return
            }
        }
        self.getAllTrips()
        
        
    }
    
    // move to trips controller
    func getAllTrips(){
        var currentUser = AuthController().getCurrentUser()
        var user = UserController().getUserByID(id: currentUser!.uid) { (User, Error) in
            print(User)
            print(Error)
        }
        
        
    }
    
    
    func createUser(id: String, email: String , trips: [DocumentReference] = []){
        let user = User()
        user.email = email
        user.trips=trips
        let userRef = userRef?.document(id)
        do {
            try userRef?.setData(from: user)
            print("User created with ID: \(id)")
        } catch {
            print("Failed to create user: \(error.localizedDescription)")
        }
    }
        
    
    func getUserByID(id: String, completion: @escaping (User?, Error?) -> Void) {
        
        userRef!.whereField("id", isEqualTo: id).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let document = querySnapshot?.documents.first else {
                completion(nil, nil)
                return
            }
            
            do {
                let user = try document.data(as: User.self)
                completion(user, nil)
            } catch {
                completion(nil, error)
            }
        }
    }

    func parseUserSnapshot(snapshot:QuerySnapshot){
        
        snapshot.documentChanges.forEach { (change) in
            var parsedUser: User?
            do {
                parsedUser = try change.document.data(as: User.self)
                var docRefs = parsedUser?.trips
                docRefs?.forEach({ docRef in
                    docRef.getDocument { (document, error) in
                        if let error = error {
                            print("Error fetching document: \(error)")
                        } else if let document = document, document.exists {
//                            let data = document.data(as: Trip.self)
                            // trips
//                            print(data)
                            // Process the data as needed
                        } else {
                            print("Document does not exist")
                        }
                    }
                })
                
            } catch {
                print("Unable to decode hero. Is the hero malformed?")
                return
            }
            
        }
        
    }
}
