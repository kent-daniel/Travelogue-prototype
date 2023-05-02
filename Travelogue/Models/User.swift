//
//  User.swift
//  Travelogue
//
//  Created by kent daniel on 27/4/2023.
//

import UIKit
import FirebaseFirestoreSwift
import FirebaseFirestore

class User: NSObject ,Codable{
    var id:String?
    var email:String?
    var trips :[DocumentReference]?
    var name: String?
    
}
