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

    @IBOutlet weak var appleAuthProviderView: UIStackView!
    @IBOutlet weak var swtRememberMe: UISwitch!
    @IBOutlet weak var txtPassword: MaterialTextInputField!
    @IBOutlet weak var txtEmail: MaterialTextInputField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initLayout()
    }
    
    func initLayout() {
        //Apple Sign In Button Set
        let authorizationButton = ASAuthorizationAppleIDButton()
        authorizationButton.addTarget(self, action: #selector(handleAppleAuth), for: .touchUpInside)
        self.appleAuthProviderView.addArrangedSubview(authorizationButton)
    }
    
    @IBAction func goSignUp(_ sender: Any) {
        self.gotoStoryBoardVC("SignUpVC", true)
    }
    
    @IBAction func login(_ sender: Any) {
        let email = txtEmail.getText()
        let password = txtPassword.getText()
        
        if email.isEmpty() {
            self.showMessage("Warning", "Please input valid email.", 1)
            return
        }
        processLogin(email: email, password: password, is_social: 0)
    }
    
    @objc func handleAppleAuth() {
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
                            self.gotoStoryBoardVC("CardRegisterVC", true)
                        }
                        else {
                            self.gotoStoryBoardVC("RecentCallVC", true)
                        }
                    }
                    else {
                        self.gotoStoryBoardVC("CardRegisterVC", true)
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
        print("****** Apple Auth Error ******\n", error)
    }
}

extension LoginVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
