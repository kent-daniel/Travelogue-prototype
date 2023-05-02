//
//  FIrebaseController.swift
//  Travelogue
//
//  Created by kent daniel on 27/4/2023.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class AuthController: NSObject {
    var authController: Auth
    var database: Firestore
    var currentUser: FirebaseAuth.User?
    override init() {
        authController = Auth.auth()
        database = Firestore.firestore()
        super.init()
        
    }
    func getCurrentUser()->FirebaseAuth.User?{
        return Auth.auth().currentUser
    }
    
    // AUTH
    func signUp(name:String , email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false, error)
            } else if let user = user {
                let newUser = Auth.auth().currentUser!
                self.currentUser = newUser
                UserController().createUser(id: newUser.uid, email: email, name: name)
                completion(true, nil)
            } else {
                completion(false, nil)
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error == nil {
                self.currentUser = Auth.auth().currentUser!
                
                completion(true, nil)
            } else {
                print(error!)
                completion(false, error)
            }
        }
    }
    
}
