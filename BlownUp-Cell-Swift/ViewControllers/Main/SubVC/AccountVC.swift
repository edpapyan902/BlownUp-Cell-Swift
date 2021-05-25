//
//  AccountVC.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 03/05/2021.
//


import Foundation
import UIKit
import Stripe

class AccountVC: BaseVC {
    
    @IBOutlet weak var imgScheduleAdd: UIImageView!
    @IBOutlet weak var swtActiveCardForm: UISwitch!
    @IBOutlet weak var creditCardProvider: CreditCardView!
    @IBOutlet weak var lblCardExp: UILabel!
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var txtPhone: TextInput!
    @IBOutlet weak var txtPassword: TextInput!
    @IBOutlet weak var lblEmail: UILabel!
    
    var m_CreditCard: CreditCard? = nil
    var m_Password = ""
    var m_SpoofPhoneNumber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initLayout()
        initData()
    }
    
    func initLayout() {
        creditCardProvider.setEnabled(false)
        
        self.imgScheduleAdd.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onScheduleAddClicked)))
    }
    
    @objc func onScheduleAddClicked() {
        self.gotoScheduleAddVC(nil)
    }
    
    func initData() {
        self.lblEmail.text = Store.instance.user?.email
        self.txtPassword.setEnabled(true)
        
        if (Store.instance.user?.is_social)! > 0 {
            self.txtPassword.setEnabled(false)
        }
        
        self.showLoading(self)
        
        API.instance.getCard() { (response) in
            self.hideLoading()
            
            if response.error == nil {
                let creditCardRes: CreditCardRes = response.result.value!
                
                if creditCardRes.success {
                    self.m_CreditCard = creditCardRes.data.card
                    
                    self.lblCardNumber.text = "XXXX XXXX XXXX " + (self.m_CreditCard?.card_number)!.subString(12, 4)
                    self.lblCardExp.text = "Expired at: " + PLUS0(Int(self.m_CreditCard!.card_expire_month)) + "/" + String(self.m_CreditCard!.card_expire_year)
                } else {
                    self.showError(creditCardRes.message)
                }
            }
        }
    }
    
    @IBAction func onSwtichValueChanged(_ sender: UISwitch) {
        creditCardProvider.setEnabled(sender.isOn)
    }
    
    @IBAction func onBtnUpdateClicked(_ sender: Any) {
        var isSavePwd = false, isSavePhone = false, isSaveCard = false
        
        let password = self.txtPassword.getText()
        if !password.isEmpty() {
            if password.count < 6 {
                self.showWarning("Password should be over 6 characters.")
            } else {
                m_Password = password
                isSavePwd = true
            }
        }
        
        let phone_number = self.txtPhone.getText()
        if phone_number.isValidePhone() && Store.instance.user?.spoof_phone_number != phone_number {
            m_SpoofPhoneNumber = phone_number.formatPhoneNumber()
            isSavePhone = true
        }
        
        if creditCardProvider.isEnabled() && creditCardProvider.getCardView().isValid {
            isSaveCard = true
        }
        
        if !isSavePwd && !isSavePhone && !isSaveCard {
            self.showWarning("There is nothing to update.")
            return
        }
        
        if isSaveCard && self.swtActiveCardForm.isOn {
            let cardView = creditCardProvider.getCardView()
            if cardView.cardNumber == m_CreditCard?.card_number && cardView.expirationMonth == m_CreditCard?.card_expire_month && cardView.expirationYear == m_CreditCard?.card_expire_year && cardView.cvc == m_CreditCard?.card_cvv {
                self.showWarning("This card already registered.")
                return
            }
            
            let paymentMethodParams = STPPaymentMethodParams(
                card: creditCardProvider.getCardView().cardParams,
                billingDetails: STPPaymentMethodBillingDetails(),
                metadata: nil
            )
            createPaymentMethod(paymentMethodParams: paymentMethodParams, isApplePay: false)
        } else {
            let params: [String: Any] = [
                "": "",
            ]
            processUpdate(params: params, isCard: true)
        }
    }
    
    func createPaymentMethod(paymentMethodParams: STPPaymentMethodParams, isApplePay: Bool) {
        self.showLoading(self)
        
        STPAPIClient.shared.createPaymentMethod(
            with: paymentMethodParams,
            completion: { paymentMethod, error in
                DispatchQueue.main.async {
                    if paymentMethod != nil {
                        self.updateCard(paymentMethod: (paymentMethod?.stripeId)!, isApplePay: isApplePay)
                    } else {
                        self.hideLoading()
                    }
                }
            })
    }
    
    func updateCard(paymentMethod: String, isApplePay: Bool) {
        let creditCardView = creditCardProvider.getCardView()
        let params: [String: Any] = [
            "payment_method": paymentMethod,
            "card_zip_code": creditCardView.postalCode!,
            "card_number": creditCardView.cardNumber!,
            "card_expire_month": creditCardView.expirationMonth,
            "card_expire_year": creditCardView.expirationYear,
            "card_cvv": creditCardView.cvc!,
        ]
        
        processUpdate(params: params, isCard: true)
    }
    
    func processUpdate(params: [String: Any], isCard: Bool) {
        var totalParams = params
        if !m_Password.isEmpty() {
            totalParams["password"] = m_Password
        }
        if !m_SpoofPhoneNumber.isEmpty() {
            totalParams["spoof_phone_number"] = m_SpoofPhoneNumber
        }
        
        self.txtPhone.clearFocus()
        self.txtPassword.clearFocus()
        
        self.showLoading(self)
        
        API.instance.updateAccount(params: totalParams) { (response) in
            self.hideLoading()
            
            if response.error == nil {
                let accountUpdateRes: AccountUpdateRes = response.result.value!
                
                if isCard && accountUpdateRes.card_success {
                    self.m_CreditCard = accountUpdateRes.data.card
                    
                    if !((accountUpdateRes.data.is_ended)!) && !((accountUpdateRes.data.is_cancelled)!) {
                        Store.instance.subscriptionUpcomingDate = (accountUpdateRes.data.upcoming_invoice)!
                    }
                    Store.instance.isSubscriptionEnded = (accountUpdateRes.data.is_ended)!
                    Store.instance.isSubscriptionCancelled = (accountUpdateRes.data.is_cancelled)!
                    
                    self.lblCardNumber.text = "XXXX XXXX XXXX " + (self.m_CreditCard?.card_number)!.subString(12, 4)
                    self.lblCardExp.text = "Expired at: " + PLUS0(Int(self.m_CreditCard!.card_expire_month)) + "/" + String(self.m_CreditCard!.card_expire_year)
                    
                    self.swtActiveCardForm.isOn = false
                    self.creditCardProvider.clear()
                    self.creditCardProvider.clearFocus()
                }
                if accountUpdateRes.password_success {
                    var user = accountUpdateRes.data.user
                    user?.token = accountUpdateRes.data.user_access_token
                    
                    Store.instance.apiToken = accountUpdateRes.data.user_access_token!
                    
                    Store.instance.user = user
                    Store.instance.rememberMe = false
                    
                    self.txtPassword.setText("")
                    self.m_Password = ""
                }
                if accountUpdateRes.spoof_phone_success && !accountUpdateRes.password_success {
                    var user = accountUpdateRes.data.user
                    user?.token = Store.instance.apiToken
                    
                    Store.instance.user = user
                    
                    self.txtPhone.setText("")
                    self.m_SpoofPhoneNumber = ""
                }
                
                self.showSuccess(accountUpdateRes.message)
            }
        }
    }
}
