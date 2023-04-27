//
//  Trip.swift
//  Travelogue
//
//  Created by kent daniel on 27/4/2023.
//

import UIKit
import FirebaseFirestoreSwift

class Trip: NSObject, Codable{
    @DocumentID var id: String?
    var name:String?

}
