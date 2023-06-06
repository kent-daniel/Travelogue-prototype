//
//  ServicesController.swift
//  Travelogue
//
//  Created by kent daniel on 4/6/2023.
//

import UIKit
import MapKit

class ServicesController:NSObject{

    static func fetchWeatherData(latitude: Double, longitude: Double, completion: @escaping (Result<(weatherLocation: String, conditionText: String, temperatureCelsius: Double), Error>) -> Void) {
        let urlString = "https://api.weatherapi.com/v1/current.json?key=bd01d92221fc4c1dade45200230406&q=" + "\(latitude),\(longitude)&aqi=no"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid API URL"])))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(WeatherData.self, from: data)
                let weatherLocation = weatherData.location.name
                let conditionText = weatherData.current.condition.text
                let temperatureCelsius = weatherData.current.temp_c
                
                completion(.success((weatherLocation, conditionText, temperatureCelsius)))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }


//    func getLocalemergency()->[ambulance , police , dispatch , fire ] Dictionary
//    https://emergencynumberapi.com/api/country/AU
//    sample response:{"disclaimer":"The data from this API is provided without any claims of accuracy, you should use this data as guidance, and do your own due diligence.","error":"","data":{"country":{"name":"Australia","ISOCode":"AU","ISONumeric":"36"},"ambulance":{"all":[""],"gsm":null,"fixed":null},"fire":{"all":[""],"gsm":null,"fixed":null},"police":{"all":[""],"gsm":null,"fixed":null},"dispatch":{"all":null,"gsm":["112"],"fixed":["000"]},"member_112":false,"localOnly":false,"nodata":false}}
//
//    func getNearbyPOI(location , resultsLimit) -> google maps richlink
//
    static func getPlaceDetails(xid: String, completion: @escaping (PlaceDetailsData?, Error?) -> Void) {
        let apiKey = "5ae2e3f221c38a28845f05b628153fc97ecf60f9af695433a4f53100"
        let urlString = "https://api.opentripmap.com/0.1/en/places/xid/\(xid)?apikey=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            // Handle invalid URL
            completion(nil, NSError(domain: "InvalidURL", code: -1, userInfo: nil))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                // Handle network error
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                // Handle empty data
                completion(nil, NSError(domain: "NoData", code: -1, userInfo: nil))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(PlaceDetailsData.self, from: data)
                
                // Access the parsed place details
                completion(response, nil)
            } catch {
                // Handle parsing error
                completion(nil, error)
            }
        }.resume()
    }
    static func fetchNearbyPOI(latitude: Double, longitude: Double, kinds:String , limit:Int, completion: @escaping ([PlaceData]?, Error?) -> Void) {
        let apiKey = "5ae2e3f221c38a28845f05b628153fc97ecf60f9af695433a4f53100"
        let radius = 5000 // 5KM
        let limit = limit
        let kinds = kinds
        let rate = 1
        
        let urlString = "https://api.opentripmap.com/0.1/en/places/radius?apikey=\(apiKey)&lat=\(latitude)&lon=\(longitude)&radius=\(radius)&limit=\(limit)&kinds=\(kinds)&rate=\(1)"
        
        guard let url = URL(string: urlString) else {
            // Handle invalid URL
            completion(nil, NSError(domain: "InvalidURL", code: -1, userInfo: nil))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                // Handle network error
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                // Handle empty data
                completion(nil, NSError(domain: "NoData", code: -1, userInfo: nil))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(PlacesResponseData.self, from: data)
                
                // Access the parsed places data
                let places = response.features
                completion(places, nil)
            } catch {
                // Handle parsing error
                completion(nil, error)
            }
        }.resume()
    }


//    private func constructQueryForOpenTrip(longitude:Double, lattitude: Double){
//    let url = https://api.opentripmap.com/0.1/en/places/radius?apikey=5ae2e3f221c38a28845f05b628153fc97ecf60f9af695433a4f53100&lat=-37.8136&lon=144.9631&radius=500&limit=10&kinds=urban_environment,foods,shops&rate=1
//
//    }

    
    


}
