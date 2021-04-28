//
//  MaterialTextInputField.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 27/04/2021.
//

import Foundation
import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextFields

@IBDesignable
class MaterialTextInputField: UIView {
    var textField: MDCOutlinedTextField!
    
    @IBInspectable var text: String!
    @IBInspectable var placeHolder: String!
    @IBInspectable var hint: String!
    @IBInspectable var inputMode: String! = "text"
    @IBInspectable var outlineActiveColor: UIColor! = UIColor.init(named: "colorPrimary")
    @IBInspectable var outlineNormalColor: UIColor! = UIColor.init(named: "colorHeavyGrey")
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        textField = MDCOutlinedTextField(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        textField.text = text
        textField.placeholder = placeHolder
        textField.label.text = hint
        textField.isSecureTextEntry = inputMode == "password"
        textField.setOutlineColor(outlineNormalColor, for: MDCTextControlState.normal)
        textField.setOutlineColor(outlineActiveColor, for: MDCTextControlState.editing)
        textField.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(textField)
    }
    
    func getText() -> String {
        return textField.text!
    }
}
