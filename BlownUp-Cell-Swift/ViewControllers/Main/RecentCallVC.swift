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
    }
    
    @IBAction func goAddSchedule(_ sender: Any) {
        self.gotoStoryBoardVC("MainTabVC")
    }
    
    @IBAction func goScheduleList(_ sender: Any) {
    }
    
    @IBAction func goMyAccount(_ sender: Any) {
    }
}
