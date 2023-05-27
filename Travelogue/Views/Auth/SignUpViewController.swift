//
//  SignUpViewController.swift
//  Travelogue
//
//  Created by kent daniel on 1/5/2023.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
class SignUpViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func signUpUser(_ sender: Any) {
        // create a new user
        AuthController().signUp(name: nameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!) { [weak self] user, error in
            guard let self = self else { return }
            if (user != nil) {
                print("Sign up successful")
                appDelegate?.currentUser = user // assign global var
                // perform segue to home
                self.performSegue(withIdentifier: "signUpToTabBar", sender: nil)
            } else {
                if let error = error {
                    let errorMessage = error.localizedDescription
                    let alert = UIAlertController(title: "Signup Failed", message: errorMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
        }
    }
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedOutside()
      
        
    }
    

    
}
