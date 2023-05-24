//
//  DateParser.swift
//  Travelogue
//
//  Created by kent daniel on 24/5/2023.
//

import UIKit

class DateParser: NSObject {
    static let defaultFormat = "dd-MM-yyyy" // Default date format
    
    static func stringFromDate(_ date: Date, format: String = defaultFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    static func dateFromString(_ string: String, format: String = defaultFormat) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: string)
    }
}
