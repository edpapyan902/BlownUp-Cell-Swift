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
    
    @IBOutlet weak var appleLoginView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
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
        self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: self.btnLogin.frame.origin.y + 50)
        
        //Apple Sign In Button Set
        let authorizationButton = ASAuthorizationAppleIDButton()
        authorizationButton.addTarget(self, action: #selector(handleAppleLogin), for: .touchUpInside)
        self.appleLoginView.addArrangedSubview(authorizationButton)
    }
    
    @IBAction func goLogin(_ sender: Any) {
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        loginVC!.modalPresentationStyle = .fullScreen
        self.present(loginVC!, animated: true, completion: nil)
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
        
        processSignUp(params: params)
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
    
    func processSignUp(params: [String: Any]) {
        API.instance.signUp(params: params) { (response) in
            if response.error == nil {
                let signUpRes: SignUpRes = response.result.value!
                
                if signUpRes.success! {
                    print("************* SignUp Success! *************")
                    
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

extension SignUpVC: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
//            let userIdentifier = appleIDCredential.user
//            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            if email!.isEmpty() {
                return
            }
            
            let spoof_phone_number = txtSpoofPhone.getText()
            if spoof_phone_number.isEmpty() {
                return
            }
            
            let params: [String: Any] = [
                "email": email!,
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
    }
}

extension SignUpVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
