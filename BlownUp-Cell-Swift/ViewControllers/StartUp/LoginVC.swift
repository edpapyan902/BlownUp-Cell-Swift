//
//  LoginVC.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 27/04/2021.
//

import Foundation
import UIKit
import AuthenticationServices

class LoginVC: BaseVC {

    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var appleLoginView: UIStackView!
    @IBOutlet weak var swtRememberMe: UISwitch!
    @IBOutlet weak var txtPassword: MaterialTextInputField!
    @IBOutlet weak var txtEmail: MaterialTextInputField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        initLayout()
    }
    
    func initLayout() {
        self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: self.btnSignUp.frame.origin.y + 50)
        
        //Apple Sign In Button Set
        let authorizationButton = ASAuthorizationAppleIDButton()
        authorizationButton.addTarget(self, action: #selector(handleAppleLogin), for: .touchUpInside)
        self.appleLoginView.addArrangedSubview(authorizationButton)
    }
    
    @IBAction func goSignUp(_ sender: Any) {
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
        processLogin(email: email, password: password, is_social: 0)
    }
    
    @objc func handleAppleLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func processLogin(email: String, password: String, is_social: Int) {
        let params: [String: Any] = [
            "email": email,
            "password": password,
            "is_social": is_social
        ]
        
        API.instance.login(params: params) { (response) in
            if response.error == nil {
                let loginRes: LoginRes = response.result.value!
                
                if loginRes.success! {
                    print("************* Login Success! *************")
                    
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

extension LoginVC: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
//            let userIdentifier = appleIDCredential.user
//            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            if email!.isEmpty() {
                return
            }
            
            processLogin(email: email!, password: "", is_social: 3)
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}

extension LoginVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
