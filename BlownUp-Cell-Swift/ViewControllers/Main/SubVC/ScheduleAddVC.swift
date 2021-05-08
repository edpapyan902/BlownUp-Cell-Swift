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
    
    var selectedContact: Contact? = nil
    var isUpdate: Bool = false
    var selectedDate: Date = Date()
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var btnPickDate: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var imgContact: UIImageView!
    @IBOutlet weak var txtNumber: TextInput!
    
    static var instance = ScheduleAddVC()
    static func getInstance() -> ScheduleAddVC {
        return instance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        ScheduleAddVC.instance = self
        
        initLayout()
    }
    
    func initLayout() {
        self.imgContact.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showContactDialog)))
        self.imgBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onBack)))
        
        selectedDate = Date()
        self.btnPickDate.setTitle(selectedDate.string(), for: .normal)
        
        datePicker.setValue(UIColor(named: "colorBlue"), forKey: "textColor")
    }
    
    @objc func showContactDialog() {
        self.gotoModalVC(VC_DIALOG_CONTACT, true)
    }
    
    @objc func onBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickDate(_ sender: UIButton) {
        let minDate = DatePickerHelper.shared.dateFrom(day: 18, month: 08, year: 1990)!
        let maxDate = DatePickerHelper.shared.dateFrom(day: 18, month: 08, year: 2030)!
        let today = Date()
        let datePicker = DatePicker()
        datePicker.setup(beginWith: today, min: minDate, max: maxDate) { (selected, date) in
            if selected, let selectedDate = date {
                self.btnPickDate.setTitle(selectedDate.string(), for: .normal)
                self.selectedDate = selectedDate
            }
        }
        datePicker.show(in: self)
    }
    
    func setContact(_ contact: Contact) {
        self.selectedContact = contact
        self.txtNumber.setText(contact.number)
    }
    
    @IBAction func addupdateSchedule(_ sender: Any) {
        if !isUpdate {
            self.addSchedule()
        } else {
            self.updateSchedule()
        }
    }
    
    func addSchedule() {
        var number = self.txtNumber.getText()
        if number.isEmpty() {
            self.showWarning("Please enter number to have a call from.")
            return
        }
        
        let date = self.datePicker.date
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let scheduled_at = selectedDate.toString("yyyy-MM-dd") + " " + PLUS0(components.hour!) + ":" + PLUS0(components.minute!)
        
        var n_id_contact = 0
        if selectedContact != nil && selectedContact?.number == number {
            n_id_contact = selectedContact!.id
            number = ""
        }
        
        let params: [String: Any] = [
            "n_id_contact": n_id_contact,
            "number": number,
            "scheduled_at": scheduled_at
        ]
        
        self.showLoading(self)
        
        API.instance.addSchedule(params: params){ (response) in
            self.hideLoading()
            
            if response.error == nil {
                let scheduleAddRes: ScheduleAddRes = response.result.value!
                if scheduleAddRes.success {
                    self.showSuccess(scheduleAddRes.message)
                    
                    let schedule = scheduleAddRes.data.schedule
                } else {
                    self.showError(scheduleAddRes.message)
                }
            }
        }
    }
    
    func updateSchedule() {
        
    }
}
