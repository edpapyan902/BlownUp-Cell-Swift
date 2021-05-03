//
//  BaseVC.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 29/04/2021.
//

import Foundation
import UIKit
import KRProgressHUD
import SwiftMessages

class BaseVC : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Rotate Restict
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
    }
    
    func gotoStoryBoardVC(_ name: String) {
        let storyboad = UIStoryboard(name: name, bundle: nil)
        let targetVC = storyboad.instantiateViewController(withIdentifier: name)

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = targetVC
        UIApplication.shared.keyWindow?.rootViewController = targetVC
    }

    func showLoading(_ viewController: UIViewController) {
        let primaryColor = UIColor.init(named: "colorPrimary")
        let styles : KRProgressHUDStyle = .custom (background: .white,text : primaryColor!, icon: primaryColor! )
        KRProgressHUD.set(style: styles)
        KRProgressHUD.set(activityIndicatorViewColors: [primaryColor!, primaryColor!])
        KRProgressHUD.showOn(viewController).show()
    }
    
    func hideLoading() {
        KRProgressHUD.dismiss()
    }
    
    func showMessage(_ body: String, _ type: Int) {
        let view = MessageView.viewFromNib(layout: .cardView)
        var title: String
        if type == 0 {
            view.configureTheme(.success)
            title = "Success"
        }
        else if type == 1 {
            view.configureTheme(.warning)
            title = "Warning"
        }
        else {
            view.configureTheme(.error)
            title = "Error"
        }
        
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        view.configureDropShadow()
        view.configureContent(title: title, body: body)
        view.button?.isHidden = true
        
        var config = SwiftMessages.Config()
        config.presentationStyle = .bottom
        
        SwiftMessages.show(config: config, view: view)
    }
    
    func showSuccess(_ message: String) {
        showMessage(message, 0)
    }
    
    func showWarning(_ message: String) {
        showMessage(message, 1)
    }
    
    func showError(_ message: String) {
        showMessage(message, 2)
    }
}
