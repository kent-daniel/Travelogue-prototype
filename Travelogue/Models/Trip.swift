//
//  Trip.swift
//  Travelogue
//
//  Created by kent daniel on 27/4/2023.
//

import UIKit
import FirebaseFirestoreSwift
import FirebaseFirestore


class Trip: NSObject, Codable{
    @DocumentID var id: String?
    var name:String?
    var admin: DocumentReference?
    var members :[DocumentReference]?
    var posts : [Post]?
    var date : Date?
    var tripDesc :String?
    var countryCode:String?
    var locationName:String?
    var itineraries : [Itinerary]?
//    var announcements

    
    

}
