//
//  SplashVC.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 27/04/2021.
//

import Foundation
import UIKit

class SplashVC: BaseVC {
    
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
                self.gotoVC(VC_CARD_REGISTER)
            }
            else if isEnded && upcoming_date != 0 {
                self.showWarning("Your subscription plan ended. Please subscribe new plan.")
                self.gotoVC(VC_CARD_REGISTER)
            }
            else {
                self.gotoVC(VC_RECENT_CALL)
            }
        }
        else {
            self.gotoVC(VC_LOGIN)
        }
    }
}
