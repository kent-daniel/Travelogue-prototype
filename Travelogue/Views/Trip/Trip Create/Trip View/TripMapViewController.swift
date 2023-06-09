//
//  TripMapViewController.swift
//  Travelogue
//
//  Created by kent daniel on 15/5/2023.
//

import UIKit
import MapKit

class TripMapViewController: UIViewController  , MKMapViewDelegate{

    @IBOutlet weak var Map: MKMapView!
    var locations: [(name: String, coordinate: CLLocationCoordinate2D, address: String, imageURL: String?)]?
    override func viewDidLoad() {
        super.viewDidLoad()
        Map.delegate = self
        plotPinsOnMap()
        centerMapOnLocations()
        // Do any additional setup after loading the view.
    }
    
    func plotPinsOnMap() {
            guard let locations = locations else {
                return
            }
            
        for location in locations {
                let annotation = MKPointAnnotation()
                annotation.title = location.name
                annotation.subtitle = location.address
                annotation.coordinate = location.coordinate
                
            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
                   annotationView.canShowCallout = true
                   annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                    annotationView.isUserInteractionEnabled = true

                   Map.addAnnotation(annotation)
            }
            
            // Zoom the map to show all the annotations
            Map.showAnnotations(Map.annotations, animated: true)
        
        }
    func centerMapOnLocations() {
        guard let locations = locations, !locations.isEmpty else {
            return
        }
        
        var totalLatitude: CLLocationDegrees = 0.0
        var totalLongitude: CLLocationDegrees = 0.0
        
        for location in locations {
            let coordinate = location.coordinate
            totalLatitude += coordinate.latitude
            totalLongitude += coordinate.longitude
        }
        
        let averageLatitude = totalLatitude / Double(locations.count)
        let averageLongitude = totalLongitude / Double(locations.count)
        
        let centerCoordinate = CLLocationCoordinate2D(latitude: averageLatitude, longitude: averageLongitude)
        
        let region = MKCoordinateRegion(center: centerCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        Map.setRegion(region, animated: true)
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // Add the following delegate method
   
        if let annotation = view.annotation, let locationName = annotation.title {
            let alert = UIAlertController(title: "Get Directions", message: "Open Maps for directions to \(locationName)?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open", style: .default) { (_) in
                let placemark = MKPlacemark(coordinate: annotation.coordinate)
                let mapItem = MKMapItem(placemark: placemark)
                mapItem.name = locationName
                mapItem.openInMaps(launchOptions: nil)
            }
            alert.addAction(openAction)
            
            present(alert, animated: true, completion: nil)
        }
            
    }
//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        if let annotation = view.annotation, let locationName = annotation.title {
//            let alert = UIAlertController(title: "Get Directions", message: "Open Maps for directions to \(locationName)?", preferredStyle: .alert)
//
//            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//            alert.addAction(cancelAction)
//
//            let openAction = UIAlertAction(title: "Open", style: .default) { (_) in
//                let placemark = MKPlacemark(coordinate: annotation.coordinate)
//                let mapItem = MKMapItem(placemark: placemark)
//                mapItem.name = locationName
//                mapItem.openInMaps(launchOptions: nil)
//            }
//            alert.addAction(openAction)
//
//            present(alert, animated: true, completion: nil)
//        }
//    }

    
//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//           if let annotation = view.annotation, let locationName = annotation.title {
//               let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
//               let placemark = MKPlacemark(coordinate: annotation.coordinate)
//               let mapItem = MKMapItem(placemark: placemark)
//               mapItem.name = locationName
//               mapItem.openInMaps(launchOptions: launchOptions)
//           }
//       }









    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
