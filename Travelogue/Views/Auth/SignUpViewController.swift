//
//  SignUpViewController.swift
//  Travelogue
//
//  Created by kent daniel on 1/5/2023.
//

import UIKit

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func signUpUser(_ sender: Any) {
        // create a new user
        AuthController().signUp(name: nameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!) { [weak self] success, error in
            guard let self = self else { return }
            if success {
                print("Sign up successful")
                NavigationHelper.navigateToHomeController(from: self)
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
        
        // Do any additional setup after loading the view.
        
        
        
    }
    
    //    @IBAction func signUp(_ sender: Any) {
    //        AuthController().signUp(email: emailTextField.text!, password: passwordTextField.text!)
    //    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
