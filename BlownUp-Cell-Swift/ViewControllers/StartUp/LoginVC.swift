//
//  LoginVC.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 27/04/2021.
//

import Foundation
import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class LoginVC: UIViewController {

    @IBOutlet weak var swtRememberMe: UISwitch!
    @IBOutlet weak var txtPassword: MaterialTextInputField!
    @IBOutlet weak var txtEmail: MaterialTextInputField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func login(_ sender: Any) {
        let email = txtEmail.getText()
        let password = txtPassword.getText()
        
        if email.isEmpty() || password.isEmpty() {
            return
        }
        
        API.instance.login(email: email.lowercased(), password: password) { (response) in
            if response.error == nil {
                let loginRes: LoginRes = response.result.value!
                print(loginRes)
            }
        }
    }
}
