//
//  LoginVC.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 27/04/2021.
//

import Foundation
import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var lblSignUp: UILabel!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var swtRememberMe: UISwitch!
    @IBOutlet weak var txtPassword: MaterialTextInputField!
    @IBOutlet weak var txtEmail: MaterialTextInputField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initLayout()
    }
    
    func initLayout() {
        self.lblSignUp.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goSignUp)))
    }
    
    @objc func goSignUp() {
        let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as? SignUpVC
        signUpVC!.modalPresentationStyle = .fullScreen
        self.present(signUpVC!, animated: true, completion: nil)
    }
    
    @IBAction func login(_ sender: Any) {
        let email = txtEmail.getText()
        let password = txtPassword.getText()
        
        if email.isEmpty() || password.isEmpty() {
            return
        }
        
        loadingView.isHidden = false
        
        API.instance.login(email: email.lowercased(), password: password) { (response) in
            self.loadingView.isHidden = true
            if response.error == nil {
                let loginRes: LoginRes = response.result.value!
                
                if loginRes.success! {
                    let data = loginRes.data
                    
                    Store.instance.apiToken = (data?.user?.token)!
                    Store.instance.setUser(key: USER_PROFILE, data: (data?.user)!)
                    Store.instance.rememberMe = self.swtRememberMe.isOn
                    
                    if (data?.is_subscribed)! {
                        if !((data?.is_ended)!) && !((data?.is_cancelled)!) {
                            Store.instance.subscriptionUpcomingDate = (data?.upcoming_invoice)!
                        }
                        Store.instance.isSubscriptionEnded = (data?.is_ended)!
                        Store.instance.isSubscriptionCancelled = (data?.is_cancelled)!
                        
                        if (data?.is_ended)! && Store.instance.subscriptionUpcomingDate != 0 {
                            let cardRegisterVC = self.storyboard?.instantiateViewController(withIdentifier: "CardRegisterVC") as? CardRegisterVC
                            cardRegisterVC!.modalPresentationStyle = .fullScreen
                            self.present(cardRegisterVC!, animated: true, completion: nil)
                        }
                        else {
                            let recentCallVC = self.storyboard?.instantiateViewController(withIdentifier: "RecentCallVC") as? RecentCallVC
                            recentCallVC!.modalPresentationStyle = .fullScreen
                            self.present(recentCallVC!, animated: true, completion: nil)
                        }
                    }
                    else {
                        let cardRegisterVC = self.storyboard?.instantiateViewController(withIdentifier: "CardRegisterVC") as? CardRegisterVC
                        cardRegisterVC!.modalPresentationStyle = .fullScreen
                        self.present(cardRegisterVC!, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
