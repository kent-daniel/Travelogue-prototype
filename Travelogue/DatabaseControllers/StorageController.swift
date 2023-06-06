//
//  PostController.swift
//  Travelogue
//
//  Created by kent daniel on 11/5/2023.
//

import UIKit
import FirebaseStorage
class StorageController{
    
    // MARK: upload image
    static func uploadImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        // Compressing image
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get image data"])
            completion(.failure(error))
            return
        }
        
        let filename = UUID().uuidString + ".jpg"
        let storageRef = Storage.storage().reference().child(filename)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let uploadTask = storageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                } else if let url = url {
                    completion(.success(url.absoluteString))
                }
            }
        }
        
        uploadTask.observe(.progress) { snapshot in
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            print("Upload progress: \(percentComplete)%")
        }
    }
    
    // MARK: update image (imageURL) -> UIImage
    
    // MARK: delete image (imageURL) -> void
    
    // MARK: get image (imageURL) -> UIImage


}


