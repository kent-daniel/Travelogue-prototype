import Foundation

struct POI {
    var address: String?
    var type: String?
    var name: String?
    var latitude: Double?
    var longitude: Double?
    var distance: String?
}

class HomeViewModel: NSObject {
    
    static func getPOINearby(lat: Double, long: Double, completion: @escaping ([POI]?, Error?) -> Void) {
        var POIList = [POI]()
        
        ServicesController.fetchNearbyPOI(latitude: lat, longitude: long, kinds: "urban_environment,foods,shops", limit: 20) { places, error in
            if let error = error {
                // Handle error
                completion(nil, error)
                return
            }
            
            guard let places = places else {
                // No places found
                completion(POIList, nil)
                return
            }
            
            let group = DispatchGroup()
            
            for place in places {
                group.enter()
                
                getPOIDetails(for: place) { poi, error in
                    if let error = error {
                        print("Error fetching POI details: \(error.localizedDescription)")
                    } else if let poi = poi {
                        POIList.append(poi)
                    }
                    
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                completion(POIList, nil)
            }
        }
    }
    
    static func getPOIDetails(for place: PlaceData, completion: @escaping (POI?, Error?) -> Void) {
        var newPOI = POI()
        
        if !place.properties.name.isEmpty {
            newPOI.name = place.properties.name
        }
        
        if let latitude = place.geometry.coordinates.last {
            newPOI.latitude = latitude
        }
        
        if let longitude = place.geometry.coordinates.first {
            newPOI.longitude = longitude
        }
        
        let kinds = place.properties.kinds
        
        if kinds.contains("foods") {
            newPOI.type = "🍴"
        } else if kinds.contains("shops") {
            newPOI.type = "🛍️"
        } else if kinds.contains("urban_environment") {
            newPOI.type = "🌳"
        }
        
        let distance = place.properties.dist
        
        newPOI.distance = String(format: "%.2f", distance / 1000)

        
        let xid = place.properties.xid
        
        ServicesController.getPlaceDetails(xid: xid) { placeDetailsData, error in
            if let error = error {
                print("Error fetching place details: \(error.localizedDescription)")
            } else if let placeDetailsData = placeDetailsData {
                newPOI.address = getAddressString(from: placeDetailsData.address)
            }
            
            completion(newPOI, error)
        }
    }
    
    static func getAddressString(from addressData: AddressData?) -> String {
        var addressComponents: [String] = []
        
        if let houseNumber = addressData?.house_number {
            addressComponents.append(houseNumber)
        }
        
        if let road = addressData?.road {
            addressComponents.append(road)
        }
        
        if let suburb = addressData?.suburb {
            addressComponents.append(suburb)
        }
        
        if let state = addressData?.state {
            addressComponents.append(state)
        }
        
        
        
        return addressComponents.joined(separator: ", ")
    }
}
