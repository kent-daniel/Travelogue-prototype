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
        requestPhotoLibraryAccessPermission()
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
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


        



        
        // Do any additional setup after loading the view.
        // make sure there is a current user
        guard let userID = AuthController().getCurrentUser()?.uid else {
            // handle the case where there is no current user
            print("No current user found.")
            return
        }
        
        // get the user document for the current user
        UserController().getUserByID(id: userID) { user, error in
            if let error = error {
                // handle the case where there is an error getting the user document
                print("Error getting user document: \(error.localizedDescription)")
                return
            }
            
            if let user = user{
                self.currentUser = user
            } else {
                // handle the case where there is no user document for the current user
                print("No user document found for current user.")
                return
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
                    break
                case .denied, .restricted:
                    // Access denied or restricted, handle the error
                    break
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
