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
    
    func gotoStoryBoardVC(_ name: String, _ fullscreen: Bool) {
        let storyboad = UIStoryboard(name: name, bundle: nil)
        let targetVC = storyboad.instantiateViewController(withIdentifier: name)
        if fullscreen {
            targetVC.modalPresentationStyle = .fullScreen
        }
        self.present(targetVC, animated: false, completion: nil)
    }
    
    func setProgressHUDStyle(_ style: Int,backcolor: UIColor,textcolor : UIColor, imagecolor : UIColor ) {
        if style != 2 {
        let styles: [KRProgressHUDStyle] = [.white, .black, .custom(background: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), text: #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1), icon: UIColor.init(named: "colorPrimary")!)]
            KRProgressHUD.set(style: styles[style]) }
        else {
            let styles : KRProgressHUDStyle = .custom (background:backcolor,text : textcolor, icon: imagecolor )
             KRProgressHUD.set(style: styles)
        }
    }
    
    func progressSet(styleVal: Int ,backColor: UIColor,textColor : UIColor , imgcolor: UIColor, headerColor : UIColor, trailColor : UIColor) {
        setProgressHUDStyle(styleVal,backcolor: backColor,textcolor : textColor, imagecolor: imgcolor)
        KRProgressHUD.set(activityIndicatorViewColors: [headerColor, trailColor])
    }

    func progShowSuccess(_ msgOn:Bool, _ msg:String) {
        self.progressSet( styleVal: 2, backColor: .white, textColor: UIColor.init(named: "colorPrimary")!, imgcolor: UIColor.init(named: "colorPrimary")!, headerColor: UIColor.init(named: "colorPrimary")!, trailColor: UIColor.init(named: "colorPrimary")!)
        KRProgressHUD.show(withMessage: nil)
//        KRProgressHUD.show(withMessage: "Loading...")
    }

    func progShowError(_ msgOn:Bool, msg:String) {
        self.progressSet( styleVal: 2, backColor: UIColor.init(named: "colorPrimary")!, textColor: .white, imgcolor: .red, headerColor: .red, trailColor: .yellow)
        KRProgressHUD.showError(withMessage: msgOn == false ? nil : msg)
    }
    
    func showMessage(_ title: String, _ type: Int) {
        let view = MessageView.viewFromNib(layout: .cardView)
        var body: String
        if type == 0 {
            view.configureTheme(.success)
            body = "Success"
        }
        else if type == 1 {
            view.configureTheme(.warning)
            body = "Warning"
        }
        else {
            view.configureTheme(.error)
            body = "Error"
        }
        
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        view.configureDropShadow()
        view.configureContent(title: title, body: body)
        view.button?.isHidden = true
        
        var config = SwiftMessages.Config()
        config.presentationStyle = .bottom
        
        SwiftMessages.show(config: config, view: view)
    }
}
