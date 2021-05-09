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
    
    var currentSchedule: Schedule? = nil
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var btnPickDate: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var imgContact: UIImageView!
    @IBOutlet weak var txtNumber: TextInput!
    
    static var instance = ScheduleAddVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        ScheduleAddVC.instance = self
        
        initLayout()
    }
    
    func initLayout() {
        self.imgContact.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showContactDialog)))
        self.imgBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onBack)))
        
        datePicker.setValue(UIColor(named: "colorBlue"), forKey: "textColor")
        
        if currentSchedule == nil {
            self.isUpdate = false
            self.btnPickDate.setTitle(Date().string(), for: .normal)
        } else {
            self.isUpdate = true
            let dateResult = currentSchedule?.scheduled_at.splite(" ")
            self.btnPickDate.setTitle(dateResult![0], for: .normal)
            self.txtNumber.setText((currentSchedule?.contact == nil ? currentSchedule?.number : currentSchedule?.contact?.number)!)
        }
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
        let schedule_date: String = self.btnPickDate.title(for: .normal)!
        let scheduled_at = schedule_date + " " + PLUS0(components.hour!) + ":" + PLUS0(components.minute!) + ":00"
        
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
                    
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.showError(scheduleAddRes.message)
                }
            }
        }
    }
    
    func updateSchedule() {
        
    }
}
