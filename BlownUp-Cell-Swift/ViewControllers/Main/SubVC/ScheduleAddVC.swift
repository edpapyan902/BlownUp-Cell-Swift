//
//  ScheduleAddVC.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 03/05/2021.
//

import Foundation
import UIKit
import DatePicker

class ScheduleAddVC: BaseVC {
    
    @IBOutlet weak var btnPickDate: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var imgContact: UIImageView!
    @IBOutlet weak var txtNumber: TextInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func initLayout() {
        self.imgContact.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showContactDialog)))
    }
    
    @objc func showContactDialog() {
        
    }
    
    @IBAction func pickDate(_ sender: UIButton) {
        let minDate = DatePickerHelper.shared.dateFrom(day: 18, month: 08, year: 1990)!
        let maxDate = DatePickerHelper.shared.dateFrom(day: 18, month: 08, year: 2030)!
        let today = Date()
        let datePicker = DatePicker()
        datePicker.setup(beginWith: today, min: minDate, max: maxDate) { (selected, date) in
            if selected, let selectedDate = date {
                self.btnPickDate.setTitle(selectedDate.string(), for: .normal)
            }
        }
        datePicker.show(in: self)
    }
    
    @IBAction func addupdateSchedule(_ sender: Any) {
        
    }
}
