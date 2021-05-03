//
//  Date.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 03/05/2021.
//

import Foundation

extension Date {

    func toString(_ format: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(for: self)!
    }
    
    func int2date(milliseconds: Int64) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(milliseconds))
    }
}
