import UIKit
import GooglePlaces
class SearchLocationViewController: UIViewController {

  var resultsViewController: GMSAutocompleteResultsViewController?
  var searchController: UISearchController?
  var resultView: UITextView?

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
        print(place.coordinate) // pass to the trip model
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        
        if let components = place.addressComponents {
            for component in components {
                if component.types.contains("country"){
                    print(component.shortName)
                }
                    
                }
            }
    }
    


  func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                         didFailAutocompleteWithError error: Error){
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // Turn the network activity indicator on and off again.
  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }

  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }
}
