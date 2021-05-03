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
        self.gotoStoryBoardVC("SignUpVC")
    }
    
    @IBAction func login(_ sender: Any) {
        let email = txtEmail.getText()
        let password = txtPassword.getText()
        
        if email.isEmpty() || !email.isValidEmail() {
            self.showWarning("Please enter valid email")
            return
        }
        if password.isEmpty() {
            self.showWarning("Please enter password")
            return
        }
        
        let params: [String: Any] = [
            "email": email.lowercased(),
            "password": password,
            "is_social": 0
        ]
        
        processLogin(params: params)
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
    
    func processLogin(params: [String: Any]) {
        self.showLoading(self)
        
        API.instance.login(params: params) { (response) in
            self.hideLoading()
            
            if response.error == nil {
                let loginRes: LoginRes = response.result.value!
                
                if loginRes.success! {
                    self.showSuccess(loginRes.message!)
                    
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
                            self.gotoStoryBoardVC("CardRegisterVC")
                        }
                        else {
                            self.gotoStoryBoardVC("RecentCallVC")
                        }
                    }
                    else {
                        self.gotoStoryBoardVC("CardRegisterVC")
                    }
                } else {
                    self.showError(loginRes.message!)
                }
            }
        }
    }
}

extension LoginVC: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            if Store.instance.appleUserId != userIdentifier {
                Store.instance.appleUserId = userIdentifier
                Store.instance.appleUserEmail = appleIDCredential.email!
            }
            
            let params: [String: Any] = [
                "email": Store.instance.appleUserEmail.lowercased(),
                "password": "",
                "is_social": 3
            ]
            
            processLogin(params: params)
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        self.showError("Apple Sign Error ->" + error.localizedDescription)
    }
}

extension LoginVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
