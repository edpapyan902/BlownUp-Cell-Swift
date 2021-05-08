//
//  DialogContactVC.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 08/05/2021.
//

import Foundation
import UIKit

class DialogContactVC: BaseVC {

    var m_Contacts = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initLayout()
        
        self.showLoading(self)
        
        initData()
    }
    
    func initLayout() {
        
    }
    
    func initData() {
        API.instance.getAllContact() {(response) in
            self.hideLoading()
//            self.refreshControl?.endRefreshing()
            
            if response.error == nil {
                let contactAllRes: ContactAllRes = response.result.value!
                
                if contactAllRes.success {
                    self.m_Contacts = contactAllRes.data.contacts!
                    
                    if self.m_Contacts.count > 0 {
//                        self.tblSchedule.reloadData()
                    }
                }
            }
        }
    }
}
