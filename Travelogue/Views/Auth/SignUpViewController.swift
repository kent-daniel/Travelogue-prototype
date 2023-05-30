//
//  SignUpViewController.swift
//  Travelogue
//
//  Created by kent daniel on 1/5/2023.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import Photos
import ProgressHUD
class SignUpViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    private var selectedImage: UIImage?
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var signUpBtn: UIButton!
    
    @IBAction func uploadProfilePic(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        if PHPhotoLibrary.authorizationStatus() == .authorized {
                // Access granted, continue logic
            print("allowed")
            self.present(imagePickerController, animated: true, completion: nil)
               
        }else{
            ImageManager.requestPhotoLibraryAccessPermission(viewcontroller: self)
           
            print("disallow")
        }
    }
    
    
    @IBAction func signUpUser(_ sender: Any) {
        // create a new user
        AuthController().createUser(email: emailTextField.text!, password: passwordTextField.text!) { [weak self] userId, error in
            guard let self = self else { return }

            if let userId = userId {
                print("Sign up successful")
                ProgressHUD.show("Signing Up")
                if let image = profileImageView.image {
                    // Show the progress HUD while uploading the image
                    var profileImageURL:String?
                    StorageController.uploadImage(image) { result in
                        switch result {
                        case .success(let imageUrl):
                            // Image uploaded successfully
                            print("Image uploaded successfully: \(imageUrl)")
                            
                            profileImageURL = imageUrl
                            // Perform segue to home
                            // Create the user without the image URL
                            let appDelegate = UIApplication.shared.delegate as? AppDelegate
                            appDelegate?.currentUser = UserController().createUser(id: userId, email: self.emailTextField.text!, name: self.nameTextField.text!, profileImgUrl: profileImageURL ?? nil)
                            ProgressHUD.dismiss()
                            self.performSegue(withIdentifier: "signUpToTabBar", sender: nil)
                            
                        case .failure(let error):
                            // Error occurred while uploading the image
                            print("Failed to upload image: \(error.localizedDescription)")
                            
                           
                            
                            // Show an alert with the error message
                            let alert = UIAlertController(title: "Image Upload Failed", message: error.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }else{
                    let appDelegate = UIApplication.shared.delegate as? AppDelegate
                    appDelegate?.currentUser = UserController().createUser(id: userId, email: self.emailTextField.text!, name: self.nameTextField.text!, profileImgUrl: nil)
                }
                
            } else {
                if let error = error {
                    let errorMessage = error.localizedDescription
                    let alert = UIAlertController(title: "Signup Failed", message: errorMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        // Dismiss the progress HUD
        ProgressHUD.dismiss()
    }

    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up views
        emailTextField.applyUnderlineStyle().setIcon(UIImage(systemName: "person.crop.square.filled.and.at.rectangle"), side: .left)
        nameTextField.applyUnderlineStyle().setIcon(UIImage(systemName: "person.crop.circle"), side: .left)
        passwordTextField.applyUnderlineStyle().setIcon(UIImage(systemName: "lock"), side: .left)
        signUpBtn.applyPrimaryCTAStyle()
        profileImageView.image = UIImage(systemName: "person.circle.fill")
        profileImageView.tintColor = .lightGray
        profileImageView.applyBorderRadius(radius: 50)
        
        hideKeyboardWhenTappedOutside()
      
        
    }
    
    // MARK: request permission
    func requestPhotoLibraryAccessPermission() {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    // Access granted, continue with your logic
                    print("allowed")
                    break
                case .denied, .restricted:
                    // Access denied or restricted, handle the error
                    // Access denied or restricted, display alert
                    let alert = UIAlertController(title: "Permission Denied", message: "Please enable photo library access in Settings to use this feature.", preferredStyle: .alert)
                  
                    
                    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Go to Settings", style: .default, handler: { action in
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }

                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.open(settingsUrl)
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                               
                case .notDetermined:
                    // Should not happen, handle the error
                    break
                case .limited:
                    break
                @unknown default:
                    // Handle the error
                    break
                }
            }
        }
    }
    
}

// MARK: image picker contreoller
extension SignUpViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                selectedImage = editedImage
                profileImageView.image = editedImage
            }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

