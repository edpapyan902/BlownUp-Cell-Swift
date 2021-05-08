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
