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
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override init() {
        super.init()
        
    }
    
    // FIXME: deperecate this
    func getCurrentUser()->FirebaseAuth.User?{
        return Auth.auth().currentUser
    }
    
    //MARK: create user
    func createUser(email: String, password: String, completion: @escaping (String?, Error?) -> Void) {
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if let error = error {
                    completion(nil, error)
                } else if let user = user {
                    let newUser = Auth.auth().currentUser
                    
                    completion(newUser?.uid, nil)
                } else {
                    completion(nil, nil)
                }
            }
        }
    // MARK: sign out
    func signOut(){
        do {
            try Auth.auth().signOut()
            self.appDelegate?.currentUser = nil
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    // MARK: sign in
    func signIn(email: String, password: String, completion: @escaping (User?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error == nil {
                let loginUserID = Auth.auth().currentUser?.uid
                UserController().getUserByID(id: loginUserID!){ (user,error) in
                    self.appDelegate?.currentUser = user
                    completion(user, nil)
                }
                
                
            } else {
                print(error!)
                completion(nil, error)
            }
        }
    }
    
}
