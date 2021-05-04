//
//  CardRegisterVC.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 28/04/2021.
//

import Foundation
import UIKit
import Stripe

class CardRegisterVC: BaseVC {

    @IBOutlet weak var creditCardProvider: CreditCardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerCard(_ sender: Any) {
        if !creditCardProvider.getCardView().isValid {
            self.showWarning("Please enter valid card infomation")
            return
        }
        
        let paymentMethodParams = STPPaymentMethodParams(
            card: creditCardProvider.getCardView().cardParams,
            billingDetails: STPPaymentMethodBillingDetails(),
            metadata: nil
        )
        createPaymentMethod(paymentMethodParams: paymentMethodParams, isApplePay: false)
    }
    
    func createPaymentMethod(paymentMethodParams: STPPaymentMethodParams, isApplePay: Bool) {
        self.showLoading(self)
        
        STPAPIClient.shared.createPaymentMethod(
            with: paymentMethodParams,
            completion: { paymentMethod, error in
                DispatchQueue.main.async {
                    if paymentMethod != nil {
                        self.processRegisterCard(paymentMethod: (paymentMethod?.stripeId)!, isApplePay: isApplePay)
                    } else {
                        self.hideLoading()
                    }
                }
        })
    }
    
    func processRegisterCard(paymentMethod: String, isApplePay: Bool) {
        let creditCardView = creditCardProvider.getCardView()
        let params: [String: Any] = [
            "payment_method": paymentMethod,
            "card_zip_code": creditCardView.postalCode!,
            "card_number": creditCardView.cardNumber!,
            "card_expire_month": creditCardView.expirationMonth,
            "card_expire_year": creditCardView.expirationYear,
            "card_cvv": creditCardView.cvc!,
        ]
        
        API.instance.addCard(params: params) { (response) in
            self.hideLoading()
            
            if response.error == nil {
                let noDataRes: NoDataRes = response.result.value!
                
                if noDataRes.success! {
                    self.showSuccess(noDataRes.message!)
                    self.gotoPageVC(VC_SUCCESS)
                } else {
                    self.showWarning(noDataRes.message!)
                }
            }
        }
    }
}
