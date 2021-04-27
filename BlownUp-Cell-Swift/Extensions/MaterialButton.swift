//
//  MaterialButton.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 27/04/2021.
//

import Foundation
import UIKit
import MaterialComponents.MaterialButtons

@IBDesignable
class MaterialButton: UIView {
    @IBInspectable var text: String!
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        let button = MDCButton()
        button.setTitle("Login", for: UIControl.State.normal)
        button.sizeToFit()
        button.minimumSize = CGSize(width: 100, height: 50)
        
        self.addSubview(button)
    }
}
