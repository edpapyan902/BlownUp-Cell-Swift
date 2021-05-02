//
//  BaseBottomNavBarVC.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 02/05/2021.
//

import Foundation
import UIKit
import MaterialComponents.MaterialBottomNavigation

class BaseBottomNavBarVC: BaseVC  {
    
    @IBOutlet weak var bottomTabView: UIView!
    var bottomNavBar = MDCBottomNavigationBar()

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let size = bottomNavBar.sizeThatFits(view.bounds.size)
        let bottomNavBarFrame = CGRect(x: 0,
                                       y: view.bounds.height - size.height,
                                       width: size.width,
                                       height: size.height)
        bottomNavBar.frame = bottomNavBarFrame
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initBottomNavBar()
    }
    
    func initBottomNavBar() {
        bottomNavBar.titleVisibility = MDCBottomNavigationBarTitleVisibility(rawValue: 1)!
        bottomNavBar.alignment = MDCBottomNavigationBarAlignment(rawValue: 1)!
        
        let scheduleItem = UITabBarItem(
            title: "Schedule",
            image: UIImage(named: "ic_calendar_off"),
            tag: 0)
        let contactItem = UITabBarItem(
            title: "Contact",
            image: UIImage(named: "ic_address_book_off"),
            tag: 1)
        let settingItem = UITabBarItem(
            title: "Setting",
            image: UIImage(named: "ic_setting_off"),
            tag: 2)
        let helpItem = UITabBarItem(
            title: "Help",
            image: UIImage(named: "ic_help_off"),
            tag: 3)
        let accountItem = UITabBarItem(
            title: "Account",
            image: UIImage(named: "ic_account_off"),
            tag: 4)
        
        bottomNavBar.selectedItemTintColor = UIColor.init(named: "colorPrimary")!
        
        bottomNavBar.items = [scheduleItem, contactItem, settingItem, helpItem, accountItem]
        bottomNavBar.selectedItem = scheduleItem
        bottomNavBar.delegate = self
        
        view.addSubview(bottomNavBar)
    }
}

extension BaseBottomNavBarVC: MDCBottomNavigationBarDelegate {
    func bottomNavigationBar(_ bottomNavigationBar: MDCBottomNavigationBar, didSelect item: UITabBarItem) {
        //Navigate to the selected view controller
        self.gotoStoryBoardVC("RecentCallVC", true)
    }
        
    func bottomNavigationBar(_ bottomNavigationBar: MDCBottomNavigationBar, shouldSelect item: UITabBarItem) -> Bool {
        //helpful to have this check to avoid reshowing the current view controller
        return bottomNavBar.selectedItem != item
    }
}

