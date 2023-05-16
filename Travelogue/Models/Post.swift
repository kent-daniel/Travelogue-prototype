//
//  Post.swift
//  Travelogue
//
//  Created by kent daniel on 11/5/2023.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class Post: NSObject , Codable {
    @DocumentID var id: String?
    var poster: DocumentReference?
    var dateTime:Date?
    var url:String?
}
