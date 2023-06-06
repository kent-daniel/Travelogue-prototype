import UIKit
import CoreLocation
import LinkPresentation

class HomePageViewController: UIViewController {
    let locationManager = CLLocationManager()
    var lat: Double?
    var long: Double?
    var POIRichLinks: [String] = []
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var weatherTemp: UILabel!
    @IBOutlet weak var weatherText: UILabel!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var weatherDataContainer: UIView!
    
    @IBOutlet weak var POICollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.distanceFilter = 200 // Update location if the user moves 200 meters
        locationManager.startUpdatingLocation()
        weatherDataContainer.applyBorderRadius(radius: 30).applyShadow()
        weatherImage.applyBorderRadius(radius: 30)
        self.weatherImage.showLoadingAnimation()
        
        
        POICollectionView.dataSource = self
        POICollectionView.delegate = self
        // Register your custom collection view cell class
        POICollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "POICollectionCell")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.startUpdatingLocation()
    }
}

extension HomePageViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let coordinate = location.coordinate
            self.lat = coordinate.latitude
            self.long = coordinate.longitude
            print("Latitude: \(coordinate.latitude), Longitude: \(coordinate.longitude)")
            
//            HomeViewModel.getPOIRichLinks(lat: self.lat!, long: self.long!) { richLinks in
//                // Update the UI with rich links
//                DispatchQueue.main.async {
//                    self.POIRichLinks = richLinks
//                    self.POICollectionView.reloadData()
//                }
//            }
            
            ServicesController.fetchWeatherData(latitude: self.lat!, longitude: self.long!) { result in
                switch result {
                case .success(let weatherData):
                    let conditionText = weatherData.conditionText
                    let temperatureCelsius = weatherData.temperatureCelsius
                    let weatherLocation = weatherData.weatherLocation
                    
                    // Downloading random weather image from Unsplash based on condition text
                    let unsplashUrl = "https://source.unsplash.com/random/600x900/?\(conditionText)"
                    ImageManager.downloadImage(from:  unsplashUrl) { image, error in
                        if let error = error {
                            // Handle the error
                            print("Error downloading weather image: \(error.localizedDescription)")
                        } else {
                            DispatchQueue.main.async {
                                self.weatherImage.image = image
                                self.weatherImage.hideLoadingAnimation()
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.placeName.text = "📍\(weatherLocation)"
                        self.weatherText.text = conditionText
                        self.weatherTemp.text = "\(temperatureCelsius)°C"
                    }
                    
                case .failure(let error):
                    // Handle the error
                    print("Error fetching weather data: \(error.localizedDescription)")
                }
            }

        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            // Handle denied or restricted authorization
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways:
            // Handle authorized always case if necessary
            break
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let errorDescription = "Error getting location: \(error.localizedDescription)"
        print(errorDescription)
    }
}

extension HomePageViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return POIRichLinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "POICollectionCell", for: indexPath) as! UICollectionViewCell
        
        let richLink = POIRichLinks[indexPath.item]
        
        // Create a LPLinkView instance
        let linkView = LPLinkView()
        linkView.frame = cell.bounds
        
        if let url = URL(string: richLink) {
            // Fetch the link metadata
            let provider = LPMetadataProvider()
            provider.startFetchingMetadata(for: url) { metadata, error in
                if let metadata = metadata {
                    // Display the link preview in the LPLinkView
                    linkView.metadata = metadata
                    
                    DispatchQueue.main.async {
                        // Add the LPLinkView to the cell's content view
                        cell.contentView.addSubview(linkView)
                    }
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}
