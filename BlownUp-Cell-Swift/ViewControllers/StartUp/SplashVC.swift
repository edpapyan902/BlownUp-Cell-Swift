//
//  SplashVC.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 27/04/2021.
//

import Foundation
import UIKit

class SplashVC: UIViewController {

    var loginVC: LoginVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.initLayout()
        self.goNext()
    }
    
    func initLayout() {
        loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        loginVC!.modalPresentationStyle = .fullScreen
    }
    
    func goNext() {
        self.present(self.loginVC!, animated: true, completion: nil)
    }
}
