//
//  Itinerary.swift
//  Travelogue
//
//  Created by kent daniel on 15/5/2023.
//

import UIKit
import FirebaseFirestoreSwift

class Itinerary: NSObject , Codable{
    @DocumentID var id: String?
    var title : String?
    var desc:String?
    var address:String?
    var coordinate:[Double]?
    var dateTime:Date?
    var imgURL:String?
    
    
}
