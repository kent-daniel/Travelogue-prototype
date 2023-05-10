//
//  Post.swift
//  Travelogue
//
//  Created by kent daniel on 11/5/2023.
//

import UIKit

class Post: NSObject , Codable {
    // user who posted
    var poster:User
    var dateTime:Date
    // date time
    // location
    var location:String?
    // url
    var url:String?
}
