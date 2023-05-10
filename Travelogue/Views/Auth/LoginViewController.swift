//
//  ViewController.swift
//  Travelogue
//
//  Created by kent daniel on 26/4/2023.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class LoginViewController: UIViewController {
    
    @IBAction func goToSignUp(_ sender: Any) {
        NavigationHelper.navigateToSignUp(from: self)
    }
    @IBAction func signIn(_ sender: Any) {
        AuthController().signIn(email: emailTextField.text!, password: passwordTextField.text!){ (success, error) in
            if success {
                // Login successful, do something
                print(Auth.auth().currentUser?.email)
                DispatchQueue.main.async { // only runs AFTER login success is assigned
                    NavigationHelper.navigateToHomeController(from: self)
                }
            } else {
                // Login failed, handle the error
                if let error = error {
                    let errorMessage = error.localizedDescription
                    let alert = UIAlertController(title: "Login Failed", message: errorMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
        }
    }
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var loginPageImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        passwordTextField.placeholder="password"
        passwordTextField.isSecureTextEntry=true
        emailTextField.placeholder="email"
        self.setUpBackgroundImage()
        
    }
        
    func setUpBackgroundImage(){
        NSLayoutConstraint.activate([
                    loginPageImage.topAnchor.constraint(equalTo: view.topAnchor),
                    loginPageImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    loginPageImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    loginPageImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                ])
        loginPageImage.contentMode = UIView.ContentMode.scaleAspectFill
        Task{
            let httpsUrl = "https://source.unsplash.com/random/600x900/?clear,sky"
            let img = await downloadImage(from: httpsUrl, into: loginPageImage)
            if let img=img{
                loginPageImage.image=img
            }
        }
    }
    
    func navigateToSignUpController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let signUpViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else {
            return
        }
        

        navigationController?.pushViewController(signUpViewController, animated: true)
    }
    
    

    
    func downloadImage(from httpsUrl: String, into imageView: UIImageView) async -> UIImage? {
        var image: UIImage?
        
        do {
            let (data, response) = try await URLSession.shared.data(from: URL(string: httpsUrl)!)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return nil
            }
            
            image = UIImage(data: data)
            
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
        
        
        return image
    }
    
    

}

