//
//  VerifyCodeVC.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 17/05/2021.
//

import Foundation
import KWVerificationCodeView

class VerifyCodeVC: BaseVC {
    
    var email = ""
    var m_VerifyCode = -1
    
    var verify_Timer: Timer? = nil
    
    @IBOutlet weak var verifyCodeView: KWVerificationCodeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func verifyCode(_ sender: Any) {
        let verifyCode = verifyCodeView.getVerificationCode()
        if verifyCode.count == 6 {
            self.showLoading(self)
            self.verify_Timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.confirmCode), userInfo: nil, repeats: false)
        }
    }
    
    @objc func confirmCode() {
        self.hideLoading()
        
        self.verify_Timer?.invalidate()
        
        let verifyCode = verifyCodeView.getVerificationCode()
        if Int(verifyCode) == m_VerifyCode {
            self.gotoResetPasswordVC(email: email)
        } else {
            self.showWarning("Please enter correct code")
        }
    }
}
