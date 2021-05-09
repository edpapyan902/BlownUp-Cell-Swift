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
    
    var tm_schedule: Timer? = nil
    
    override func viewDidLoad() {
        if type == 1 {
            self.selectedIndex = 0
            
            self.tm_schedule = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(self.gotoScheduleAdd), userInfo: nil, repeats: false)
        } else if type == 0 || type == 2 {
            self.selectedIndex = 0
        } else if type == 3 {
            self.selectedIndex = 4
        }
    }
    
    @objc func gotoScheduleAdd() {
        self.tm_schedule?.invalidate()
        
        let storyboad = UIStoryboard(name: VC_SCHEDULE_ADD, bundle: nil)
        let targetVC = storyboad.instantiateViewController(withIdentifier: VC_SCHEDULE_ADD) as! ScheduleAddVC
        targetVC.currentSchedule = nil
        targetVC.modalPresentationStyle = .fullScreen
        self.present(targetVC, animated: false, completion: nil)
    }
}
