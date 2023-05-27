//
//  ViewController.swift
//  Travelogue
//
//  Created by kent daniel on 26/4/2023.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import ProgressHUD

class LoginViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    @IBAction func signIn(_ sender: Any) {
        AuthController().signIn(email: emailTextField.text!, password: passwordTextField.text!){ (user, error) in
            if (user != nil) {
                DispatchQueue.main.async { // only runs AFTER login success is assigned
                    self.appDelegate?.currentUser = user
                    self.performSegue(withIdentifier: "signInToTabBar", sender: nil)
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
        hideKeyboardWhenTappedOutside()
        // Get the app delegate and cast it to your custom AppDelegate class
        
        // Check if the user is already signed in
        if Auth.auth().currentUser != nil {
            // User is already signed in, set the current user property
            print(Auth.auth().currentUser?.email!)
            
            let currentUserId = Auth.auth().currentUser!.uid
            
            
            ProgressHUD.show("Fetching user data ...", icon: .privacy, delay: 2.0)
            ProgressHUD.animationType = .circleStrokeSpin

            UserController().getUserByID(id: currentUserId) { user, error in
                if let error = error {
                    // Handle error
                    print(error)
                } else {
                    // User object is available
                    print(user)
                    
                    let appDelegate = UIApplication.shared.delegate as? AppDelegate
                    appDelegate?.currentUser = user
                    
                    self.performSegue(withIdentifier: "signInToTabBar", sender: nil)
                    
                }
               
            }

            
        }
        self.setUpBackgroundImage()
        
    }
        
    func setUpBackgroundImage() {
        let httpsUrl = "https://source.unsplash.com/random/600x900/?sky"
        ImageDownloadHelper.downloadImage(from: httpsUrl) { (image, error) in
            if let img = image {
                self.loginPageImage.image = img
            } else {
                print("Error downloading image: \(error?.localizedDescription ?? "unknown error")")
            }
        }
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

