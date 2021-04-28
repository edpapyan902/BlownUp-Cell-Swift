//
//  SplashVC.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 27/04/2021.
//

import Foundation
import UIKit

class SplashVC: UIViewController {
    
    var loadTimer: Timer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        getSubscriptionStatus()
    }
    
    func getSubscriptionStatus() {
        if Store.instance.apiToken.isEmpty() {
            self.loadTimer = Timer.scheduledTimer(timeInterval: 0.0, target: self, selector: #selector(self.goNext), userInfo: nil, repeats: true)
        }
        else {
            API.instance.getSubscriptionStatus() { (response) in
                if response.error == nil {
                    let subscriptionRes: SubscriptionRes = response.result.value!
                    
                    if subscriptionRes.success! {
                        let data = subscriptionRes.data
                        
                        if !((data?.is_ended)!) && !((data?.is_cancelled)!) {
                            Store.instance.subscriptionUpcomingDate = (data?.upcoming_invoice)!
                        }
                        Store.instance.isSubscriptionEnded = (data?.is_ended)!
                        Store.instance.isSubscriptionCancelled = (data?.is_cancelled)!
                    }
                }
                
                self.goNext()
            }
        }
    }
    
    @objc func goNext() {
        if loadTimer != nil {
            loadTimer?.invalidate()
        }
        
        let rememberMe = Store.instance.rememberMe
        let apiToken = Store.instance.apiToken
        let isEnded = Store.instance.isSubscriptionEnded
        let isCancelled = Store.instance.isSubscriptionCancelled
        let upcoming_date = Store.instance.subscriptionUpcomingDate
        
        if !apiToken.isEmpty() && rememberMe {
            if !isCancelled && upcoming_date == 0 {
                let cardRegisterVC = self.storyboard?.instantiateViewController(withIdentifier: "CardRegisterVC") as? CardRegisterVC
                cardRegisterVC!.modalPresentationStyle = .fullScreen
                self.present(cardRegisterVC!, animated: true, completion: nil)
            }
            else if isEnded && upcoming_date != 0 {
                print("Your subscription plan ended. Please subscribe new plan.")
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
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
            loginVC!.modalPresentationStyle = .fullScreen
            self.present(loginVC!, animated: true, completion: nil)
        }
    }
}
