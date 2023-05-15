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
    @IBOutlet weak var ImageContainer: UIImageView!
    
    @IBOutlet weak var chosenTrip: UIButton!
    
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
        guard let image = selectedImage else {
            print("No image selected.")
            return
        }
        
        PostController.uploadImage(image , for: self.selectedTrip , currentUser: self.currentUser) { result in
            switch result {
            case .success(let url):
                self.savePost(with: url)
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
        
        TripController().getCurrentUserTrips { trips in
            if let trips = trips {
                self.userTrips = trips
                // Create a pull-down menu
                let menu = UIMenu(title: "Choose a trip", children: (self.userTrips ?? []).compactMap { trip in
                    let tripName = trip.name
                    return UIAction(title: tripName!, handler: { _ in
                        // Set the selected trip ID to the ID of the selected trip
                        self.selectedTrip = trip
                        // Update the title of the button to show the selected trip name
                        self.chosenTrip.setTitle(tripName, for: .normal)
                    })
                })
                // Assign the pull-down menu to the button
                self.chosenTrip.menu = menu
            } else {
                // Handle the error case
                print("Error retrieving trips")
            }
        }


        



        
        
        
    }
    
    func savePost(with imageUrl: URL) {
        // Use the URL to create a new post document in Firebase Firestore
        print("Image URL: \(imageUrl.absoluteString)")
        // ...
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
