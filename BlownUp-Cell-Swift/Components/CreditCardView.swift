//
//  CreditCardView.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 02/05/2021.
//

import Foundation
import Stripe

@IBDesignable
class CreditCardView: UIStackView {
    var paymentCardTextField: STPPaymentCardTextField!
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        paymentCardTextField = STPPaymentCardTextField(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.width))
        self.addArrangedSubview(paymentCardTextField)
    }
    
    func getCardView() -> STPPaymentCardTextField {
        return paymentCardTextField
    }
    
    func setEnabled(_ enabled: Bool) {
        paymentCardTextField.isEnabled = enabled
    }
    
    func isEnabled() -> Bool {
        return paymentCardTextField.isEnabled
    }
}
