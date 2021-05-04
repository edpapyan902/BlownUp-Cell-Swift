//
//  RecentCallVC.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 28/04/2021.
//

import Foundation
import UIKit

class RecentCallVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setStatusBarStyle(true)
        
        self.initData()
    }
    
    @IBAction func goAddSchedule(_ sender: Any) {
        self.gotoMainVC(1)
    }
    
    @IBAction func goScheduleList(_ sender: Any) {
        self.gotoMainVC(2)
    }
    
    @IBAction func goMyAccount(_ sender: Any) {
        self.gotoMainVC(3)
    }
    
    func initData() {
        self.showLoading(self)
        
        API.instance.getRecentCall() {(response) in
            self.hideLoading()
            
            if response.error == nil {
                let recentCallRes: RecentCallRes = response.result.value!
                
                if recentCallRes.success {
                    
                }
            }
        }
    }
}
