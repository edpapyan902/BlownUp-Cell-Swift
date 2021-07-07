//
//  Utils.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 08/05/2021.
//

import Foundation
import UIKit
import Kingfisher

func getImageFromUrl(imageView: UIImageView, photoUrl: String, completion: @escaping ( _ response: UIImage?) -> Void) -> Void {
    guard let url = URL.init(string: photoUrl) else {
        return
    }
    imageView.kf.setImage(
        with: url,
        options: [
            .cacheOriginalImage
        ])
    {
        result in
        switch result {
        case .success(let value):
            completion(value.image)
        case .failure(let error):
            print("Image loader error:\(error)")
            print("Image URL======>\(photoUrl)")
            completion(nil)
        }
    }
}

func PLUS0(_ value: Int) -> String {
    return value < 10 ? "0" + String(value) : String (value)
}

func STR2DATE(dateString: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    if let date = dateFormatter.date(from: dateString) {
        return date
    }
    return Date()
}

func getRelativeTime(_ scheduled_at: String, _ isServer: Bool) -> String {
    //  Convert time by EST
    let timezoneOffset = SERVER_TIME_OFFSET_BY_GMT - TimeZone.current.secondsFromGMT()
    var timezoneEpochOffset = (STR2DATE(dateString: scheduled_at).timeIntervalSince1970 + Double(timezoneOffset))
    if !isServer {
        timezoneEpochOffset = (STR2DATE(dateString: scheduled_at).timeIntervalSince1970 - Double(timezoneOffset))
    }
    let timeZoneOffsetDate = Date(timeIntervalSince1970: timezoneEpochOffset)
    return timeZoneOffsetDate.toString("yyyy-MM-dd hh:mm:ss")
}
