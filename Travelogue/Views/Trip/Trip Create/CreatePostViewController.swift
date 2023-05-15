//
//  CreatePostViewController.swift
//  Travelogue
//
//  Created by kent daniel on 11/5/2023.
//

import UIKit
import Photos

class CreatePostViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    private var selectedImage: UIImage?
    var currentUser:User?
    var userTrips:[Trip]?
    var selectedTrip:Trip?
    var activityIndicator: UIActivityIndicatorView?

    @IBOutlet weak var ImageContainer: UIImageView!
    
    @IBAction func addPic(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        if PHPhotoLibrary.authorizationStatus() == .authorized {
                // Access granted, continue with your logic
            print("allowed")
            self.present(imagePickerController, animated: true, completion: nil)
                //self.present(imagePickerController, animated: true, completion: nil)
        }else{
            requestPhotoLibraryAccessPermission()
            print("disallow")
        }
        
        
    }

    @IBAction func savePost(_ sender: Any) {
        self.activityIndicator?.startAnimating()
        guard let image = selectedImage else {
            print("No image selected.")
            return
        }
        
        PostController.uploadImage(image , for: self.selectedTrip , currentUser: self.currentUser) { result in
            switch result {
            case .success(let url):
                print(url)
                
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                    self.activityIndicator?.stopAnimating()
                }
            case .failure(let error):
                print("Failed to upload image: \(error.localizedDescription)")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create an array of trip names
        // Create an array of trip names
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.currentUser = appDelegate?.currentUser
        
        // Initialize the activity indicator
            activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator?.center = view.center
            activityIndicator?.hidesWhenStopped = true
        view.addSubview(activityIndicator!)
    }
    
   
    
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
                @unknown default:
                    // Handle the error
                    break
                }
            }
        }
    }
}

extension CreatePostViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = pickedImage
            ImageContainer.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
