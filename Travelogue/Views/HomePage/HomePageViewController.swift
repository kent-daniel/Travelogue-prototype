import UIKit
import CoreLocation

class HomePageViewController: UIViewController {
    
    var locationManager: CLLocationManager?
    var currentLocation : [Double]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        
        getCurrentLocation { (coordinate, error) in
                    if let error = error {
                        print("Error getting location: \(error.localizedDescription)")
                    } else if let coordinate = coordinate {
                        print("Latitude: \(coordinate.latitude), Longitude: \(coordinate.longitude)")
                        self.currentLocation = [coordinate.latitude,coordinate.longitude]
                    }
                }
        
        
    }
    
    func getCurrentLocation(completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.startUpdatingLocation()
        
        // Closure to be called when the location is obtained
        let handler: (CLLocationCoordinate2D?, Error?) -> Void = { coordinate, error in
            completion(coordinate, error)
            self.locationManager?.stopUpdatingLocation()
        }
        
        // If location services are not enabled, call the completion handler with an error
        guard CLLocationManager.locationServicesEnabled() else {
            handler(nil, NSError(domain: "com.myapp", code: -1, userInfo: nil))
            return
        }
        
        // Check authorization status and request permission if necessary
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == .notDetermined {
            locationManager?.requestWhenInUseAuthorization()
            return
        } else if authorizationStatus == .denied || authorizationStatus == .restricted {
            handler(nil, NSError(domain: "com.myapp", code: -2, userInfo: nil))
            return
        }
        
        // Get the current location
        if let location = locationManager?.location {
            handler(location.coordinate, nil)
        } else {
            handler(nil, NSError(domain: "com.myapp", code: -3, userInfo: nil))
        }
    }
}

extension HomePageViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let coordinate = location.coordinate
            print("latitude: \(coordinate.latitude), longitude: \(coordinate.longitude)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location: \(error.localizedDescription)")
    }
}
