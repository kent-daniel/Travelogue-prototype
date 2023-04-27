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
        
//        Task {
//            do {
//                let authDataResult = try await authController.signInAnonymously()
//                currentUser = authDataResult.user
//            }
//            catch {
//                fatalError("Firebase Authentication Failed with Error")
//            }
//
//
//        }
    }
    func getCurrentUser()->FirebaseAuth.User?{
        return Auth.auth().currentUser
    }
    
    // AUTH
    func signUp(email: String, password: String) -> Bool{
        var signupSuccess=false
        Auth.auth().createUser(withEmail: email, password: password)
        { (user, error) in
            if error == nil{
                self.currentUser = Auth.auth().currentUser!
                
                signupSuccess=true
                UserController().createUser(id: self.currentUser!.uid, email: email)
            }else{
                print(error)
            }
            
        }
        return signupSuccess
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
