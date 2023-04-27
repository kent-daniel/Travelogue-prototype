//
//  ViewController.swift
//  Travelogue
//
//  Created by kent daniel on 26/4/2023.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class ViewController: UIViewController {
    var loginSuccess=false
    
    @IBAction func signUp(_ sender: Any) {
        AuthController().signUp(email: emailTextField.text!, password: passwordTextField.text!)
    }
    
    @IBAction func signIn(_ sender: Any) {
        AuthController().signIn(email: emailTextField.text!, password: passwordTextField.text!){ (success, error) in
            if success {
                // Login successful, do something
                print("yes")
                print(Auth.auth().currentUser?.email)
                DispatchQueue.main.async { // only runs AFTER login success is assigned
                    self.loginSuccess=true
                }
            } else {
                // Login failed, handle the error
                if let error = error {
                    let errorMessage = error.localizedDescription
                    let alert = UIAlertController(title: "Login Failed", message: errorMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    self.loginSuccess=false
                    
                }
            }
        }
    }
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        passwordTextField.placeholder="password"
        passwordTextField.isSecureTextEntry=true
        emailTextField.placeholder="email"
    }
        
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "homePageSegue" && loginSuccess {
            // Prevent segue if login failed
            return false
        }
        return true
    
    }

}

