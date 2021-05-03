//
//  MainVC.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 28/04/2021.
//

import Foundation
import UIKit

class MainTabVC: UITabBarController {
    var type: Int = 0
    
    override func viewDidLoad() {
        if type == 0 || type == 1 || type == 2 {
            self.selectedIndex = 0
        } else if type == 3 {
            self.selectedIndex = 4
        }
    }
}
