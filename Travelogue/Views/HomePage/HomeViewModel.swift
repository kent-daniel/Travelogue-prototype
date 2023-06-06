import Foundation
class HomeViewModel: NSObject {
    static func getPOINearby(lat: Double, long: Double, completion: @escaping ([String]) -> Void) {
        var POIList = [String]()
        ServicesController.fetchNearbyPOI(latitude: lat, longitude: long) { places, error in
            if let error = error {
                // Handle error
                print("Error: \(error.localizedDescription)")
                completion(POIList) // Return empty list if there's an error
            } else if let places = places {
                // Use the fetched places array
                let group = DispatchGroup()
                
                for place in places {
                    let name = place.properties.name ?? ""
                    let latitude = place.geometry.coordinates.last
                    let longitude = place.geometry.coordinates.first
                    let id = place.properties.xid
                    
                    group.enter()
                    ServicesController.getPlaceDetails(xid: id){
                        PlaceDetailsData,error  in
                        print(PlaceDetailsData)
                        POIList.append(PlaceDetailsData!.address!.road!)
                    }
                }
                
                group.notify(queue: .main) {
                    completion(POIList)
                }
            } else {
                completion(POIList) // Return empty list if no places found
            }
        }
    }
}
