import UIKit
import Photos

class ImageManager {
    
    private static let imageCache = NSCache<NSString, UIImage>()

        static func downloadImage(from urlString: String, completion: @escaping (UIImage?, Error?) -> Void) {
            
            let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            // Check if the image is already cached
            if let cachedImage = imageCache.object(forKey: urlString as! NSString) {
                completion(cachedImage, nil)
                return
            }
            
            guard let url = URL(string: urlString!) else {
                completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else {
                    completion(nil, error)
                    return
                }
                
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        // Cache the downloaded image
                        imageCache.setObject(image, forKey: urlString as! NSString)
                        completion(image, nil)
                    } else {
                        completion(nil, NSError(domain: "Invalid Image Data", code: 0, userInfo: nil))
                    }
                }
            }
            
            task.resume()
        }
    
        
    // MARK: Request permission
    static func requestPhotoLibraryAccessPermission(viewcontroller: UIViewController) {
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    switch status {
                    case .authorized:
                        // Access granted, continue with your logic
                        print("Allowed")
                    case .denied, .restricted:
                        // Access denied or restricted, handle the error
                        let alert = UIAlertController(title: "Permission Denied", message: "Please enable photo library access in Settings to use this feature.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                        alert.addAction(UIAlertAction(title: "Go to Settings", style: .default, handler: { _ in
                            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(settingsURL)
                            }
                        }))
                        
                        viewcontroller.present(alert, animated: true, completion: nil)
                       
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
