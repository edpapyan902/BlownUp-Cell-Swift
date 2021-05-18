//
//  ForgetPasswordVC.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 17/05/2021.
//

import Foundation

class ForgetPasswordVC: BaseVC {
    
    @IBOutlet weak var txtEmail: TextInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func sendMail(_ sender: Any) {
        let email = txtEmail.getText()
        if !email.isValidEmail() {
            self.showWarning("Please enter vaild email address")
            return
        }
        
        let params: [String: Any] = [
            "email": email
        ]
        
        self.showLoading(self)
        
        API.instance.forgetPassword(params: params) { (response) in
            self.hideLoading()
            
            if response.error == nil {
                let forgetPasswordRes: ForgetPasswordRes = response.result.value!
                if forgetPasswordRes.success {
                    self.showSuccess(forgetPasswordRes.message)
                    
                    print("verify code", forgetPasswordRes.data.verify_code)
                    
                    self.gotoVerifyCodeVC(email: email, verify_code: forgetPasswordRes.data.verify_code)
                } else {
                    self.showError(forgetPasswordRes.message)
                }
            }
        }
    }
}
