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
//    var description -> string
//    var itineraries // sub coll
//    var announcements
//    var locations -> real time DB
//      var posts
    
    

}
