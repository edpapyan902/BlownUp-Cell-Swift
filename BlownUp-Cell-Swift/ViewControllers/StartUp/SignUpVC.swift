//
//  SignUpVC.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 27/04/2021.
//

import Foundation
import UIKit

class SignUpVC: UIViewController {
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var swtTerm: UISwitch!
    @IBOutlet weak var txtSpoofPhone: MaterialTextInputField!
    @IBOutlet weak var txtConPwd: MaterialTextInputField!
    @IBOutlet weak var txtPwd: MaterialTextInputField!
    @IBOutlet weak var txtEmail: MaterialTextInputField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUp(_ sender: Any) {
        let email = txtEmail.getText()
        let password = txtPwd.getText()
        let conPassword = txtConPwd.getText()
        let spoof_phone_number = txtSpoofPhone.getText()
        
        if email.isEmpty() {
            return
        }
        if password.isEmpty() {
            return
        }
        if conPassword.isEmpty() {
            return
        }
        if spoof_phone_number.isEmpty() {
            return
        }
        
        let params: [String: Any] = [
            "email": email,
            "password": password,
            "spoof_phone_number": spoof_phone_number,
            "term": self.swtTerm.isOn,
            "is_social": 0
        ]
        
        self.loadingView.isHidden = false
        
        API.instance.signUp(params: params) { (response) in
            self.loadingView.isHidden = true
            if response.error == nil {
                let signUpRes: SignUpRes = response.result.value!
                
                if signUpRes.success! {
                    let data = signUpRes.data
                    
                    Store.instance.apiToken = (data?.user?.token)!
                    Store.instance.setUser(key: USER_PROFILE, data: (data?.user)!)
                    Store.instance.rememberMe = true
                    
                    let cardRegisterVC = self.storyboard?.instantiateViewController(withIdentifier: "CardRegisterVC") as? CardRegisterVC
                    cardRegisterVC!.modalPresentationStyle = .fullScreen
                    self.present(cardRegisterVC!, animated: true, completion: nil)
                }
            }
        }
        
    }
}
