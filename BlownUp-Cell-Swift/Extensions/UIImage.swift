//
//  UIImage.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 10/05/2021.
//

import Foundation
import UIKit

public enum ImageFormat {
    case PNG
    case JPEG
}

extension UIImage {
    
    public func base64(format: ImageFormat) -> String {
        var imageData: NSData
        switch format {
        case .PNG: imageData = self.pngData() as! NSData
        case .JPEG: imageData = UIImageJPEGRepresentation(self, compression)
        }
        return imageData.base64EncodedStringWithOptions(.allZeros)
    }
}
