//
//  SignUpVC.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 27/04/2021.
//

import Foundation
import UIKit
import AuthenticationServices

class SignUpVC: BaseVC {
    
    @IBOutlet weak var appleAuthProviderView: UIStackView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var swtTerm: UISwitch!
    @IBOutlet weak var txtSpoofPhone: MaterialTextInputField!
    @IBOutlet weak var txtConPwd: MaterialTextInputField!
    @IBOutlet weak var txtPwd: MaterialTextInputField!
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
    
    @IBAction func goLogin(_ sender: Any) {
        self.gotoStoryBoardVC("LoginVC", true)
    }
    
    @IBAction func signUp(_ sender: Any) {
        let email = txtEmail.getText()
        let password = txtPwd.getText()
        let conPassword = txtConPwd.getText()
        let spoof_phone_number = txtSpoofPhone.getText()
        
        if email.isEmpty() || !email.isValidEmail() {
            self.showMessage("Please enter valid email", 1)
            return
        }
        if password.count < 6 {
            self.showMessage("Password should be at least 6 characters", 1)
            return
        }
        if conPassword != password {
            self.showMessage("Please enter correct confirm password", 1)
            return
        }
        if spoof_phone_number.isEmpty() {
            self.showMessage("Please enter my call to phone number", 1)
            return
        }
        
        let params: [String: Any] = [
            "email": email.lowercased(),
            "password": password,
            "spoof_phone_number": spoof_phone_number,
            "term": self.swtTerm.isOn,
            "is_social": 0
        ]
        
        processSignUp(params: params)
    }
    
    @objc func handleAppleAuth() {
        let spoof_phone_number = txtSpoofPhone.getText()
        if spoof_phone_number.isEmpty() {
            self.showMessage("Please enter my call to phone number", 1)
            return
        }
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func processSignUp(params: [String: Any]) {
        self.showLoading(self)
        
        API.instance.signUp(params: params) { (response) in
            self.hideLoading()
            
            if response.error == nil {
                let signUpRes: SignUpRes = response.result.value!
                
                if signUpRes.success! {
                    self.showMessage(signUpRes.message!, 0)
                    
                    let data = signUpRes.data
                    
                    Store.instance.apiToken = (data?.user?.token)!
                    Store.instance.setUser(key: USER_PROFILE, data: (data?.user)!)
                    Store.instance.rememberMe = true
                    
                    self.gotoStoryBoardVC("CardRegisterVC", true)
                } else {
                    self.showMessage(signUpRes.message!, 2)
                }
            }
        }
    }
}

extension SignUpVC: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
//            let userIdentifier = appleIDCredential.user
            let email = appleIDCredential.email
            
            let spoof_phone_number = txtSpoofPhone.getText()
            if spoof_phone_number.isEmpty() {
                self.showMessage("Please enter my call to phone number", 1)
                return
            }
            
            let params: [String: Any] = [
//                "userIdentifier": userIdentifier,
                "email": email!.lowercased(),
                "password": "",
                "spoof_phone_number": spoof_phone_number,
                "term": self.swtTerm.isOn,
                "is_social": 3
            ]
            
            processSignUp(params: params)
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        self.showMessage("Apple Sign Error ->" + error.localizedDescription, 2)
    }
}

extension SignUpVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
