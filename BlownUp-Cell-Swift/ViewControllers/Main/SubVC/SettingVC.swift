//
//  SettingVC.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 03/05/2021.
//

import Foundation
import UIKit

class SettingVC: BaseVC {

    var m_Invoices: [Invoice]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initData()
    }
    
    func initData() {
        self.showLoading(self)
        
        API.instance.getBillingHistory() { (response) in
            self.hideLoading()
            
            if response.error == nil {
                let invoiceRes: InvoiceRes = response.result.value!
                
                if invoiceRes.success! {
                    self.m_Invoices = invoiceRes.data?.invoices?.data
                } else {
                    self.showError(invoiceRes.message!)
                }
            }
        }
    }
}
