import UIKit

class ImageDownloadHelper {
    static func downloadImage(from urlString: String, completion: @escaping (UIImage?, Error?) -> Void) {
        guard let url = URL(string: urlString) else {
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
                    completion(image, nil)
                } else {
                    completion(nil, NSError(domain: "Invalid Image Data", code: 0, userInfo: nil))
                }
            }
        }
        
        task.resume()
    }
}
