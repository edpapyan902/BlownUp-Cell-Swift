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
                        self.processCharge(paymentMethod: (paymentMethod?.stripeId)!)
                    } else {
                        self.hideLoading()
                    }
                }
            })
    }
    
    func processCharge(paymentMethod: String) {
        let params: [String: Any] = [
            "payment_method": paymentMethod
        ]
        
        API.instance.charge(params: params) { (response) in
            self.hideLoading()
            
            if response.error == nil {
                let noDataRes: NoDataRes = response.result.value!
                
                if noDataRes.success {
                    self.showSuccess(noDataRes.message)
                    self.gotoPageVC(VC_SUCCESS)
                } else {
                    self.showWarning(noDataRes.message)
                }
            }
        }
    }
}
