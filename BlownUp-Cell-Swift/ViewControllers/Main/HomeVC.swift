//
//  MainVC.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 28/04/2021.
//

import Foundation
import UIKit
import MaterialComponents.MaterialBottomNavigation

class HomeVC: BaseVC {
    
    @IBOutlet weak var bottomTabView: UIView!
    var bottomNavBar = MDCBottomNavigationBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initLayout()
    }
    
    func initLayout() {
        self.bottomTabView.addSubview(bottomNavBar)
        
        let scheduleItem = UITabBarItem(
            title: "Schedule",
            image: UIImage(named: "ic_calendar_off"),
            selectedImage: UIImage(named: "ic_calendar_on"))
        let contactItem = UITabBarItem(
            title: "Contact",
            image: UIImage(named: "ic_contact_off"),
            selectedImage: UIImage(named: "ic_contact_on"))
        let settingItem = UITabBarItem(
            title: "Setting",
            image: UIImage(named: "ic_setting_off"),
            selectedImage: UIImage(named: "ic_setting_on"))
        let helpItem = UITabBarItem(
            title: "Help",
            image: UIImage(named: "ic_help_off"),
            selectedImage: UIImage(named: "ic_help_on"))
        let accountItem = UITabBarItem(
            title: "Account",
            image: UIImage(named: "ic_account_off"),
            selectedImage: UIImage(named: "ic_account_on"))
        
        bottomNavBar.items = [scheduleItem, contactItem, settingItem, helpItem, accountItem]
        bottomNavBar.selectedItem = scheduleItem
    }
}
