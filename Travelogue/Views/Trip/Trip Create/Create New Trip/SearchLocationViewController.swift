import UIKit
import GooglePlaces
import GoogleMaps



protocol SearchLocationViewControllerDelegate: NSObjectProtocol {
    func didSelectLocation(_ location: Location)
}

struct Location {
    var coordinate: [Double]?
    var name: String?
    var address: String?
    var countryCode: String?
    var description: String?
}


class SearchLocationViewController: UIViewController {
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var location = Location()
    weak var delegate: SearchLocationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
    }
}

// Handle the user's selection.
extension SearchLocationViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        var coordinate = place.coordinate
        var name = place.name
        var address = place.formattedAddress
        var countryCode : String?
        print("Place attributions: \(place.attributions)")
        
        if let components = place.addressComponents {
            for component in components {
                if component.types.contains("country"){
                    print(component.shortName)
                    countryCode = component.shortName
                }
                
            }
        }
        
        location = Location(coordinate: [place.coordinate.latitude, place.coordinate.longitude] , name: name , address: address , countryCode: countryCode)
        
        // alert the user to confirm selection and pop view controller if they confirm
        // Create the confirmation alert
            let alertController = UIAlertController(title: "Confirm Selection", message: "Are you sure you want to select \(place.name ?? "")?", preferredStyle: .alert)
            
            // Add action for confirming the selection
            let confirmAction = UIAlertAction(title: "Confirm", style: .default) { _ in
                // Pass the location to the delegate
                self.delegate?.didSelectLocation(self.location)
                
                // Pop the view controller
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(confirmAction)
            
            // Add cancel action
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            // Present the alert
            present(alertController, animated: true, completion: nil)
        
        
    }
    
    
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    
    
    
//    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//        // Get the place name from 'GMSAutocompleteViewController'
//        // Then display the name in textField
//        // Dismiss the GMSAutocompleteViewController when something is selected
//        print(location)
//        delegate?.didSelectLocation(location)
//        dismiss(animated: true, completion: nil)
//      }
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
