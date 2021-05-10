//
//  ContactAddVC.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 03/05/2021.
//

import Foundation
import UIKit

class ContactAddVC: BaseVC {

    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var txtNumber: TextInput!
    @IBOutlet weak var txtName: TextInput!
    @IBOutlet weak var imgContactAdd: UIImageView!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var avatarView: UIView!
    
    var currentContact: Contact? = nil
    
    var avatarBase64: String = ""
    
    var imagePicker: ImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initLayout()
    }
    
    func initLayout() {
        self.imgAvatar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.pickImage)))
        self.imgContactAdd.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showContact)))
        
        self.avatarView.makeRounded(100)
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        if currentContact != nil {
            getImageFromUrl(imageView: self.imgAvatar, photoUrl: BASE_SERVER + currentContact!.avatar) { (image) in
                if image != nil {
                    self.imgAvatar.image = image
                }
            }
        }
    }
    
    @objc func onBack() {
        self.currentContact = nil
        self.avatarBase64 = ""
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func showContact() {
        
    }
    
    @objc func pickImage() {
        self.imagePicker.present(from: self.imgAvatar)
    }
    
    @IBAction func addupdateContact(_ sender: Any) {
        if self.currentContact == nil {
            self.addContact()
        } else {
            self.updateContact()
        }
    }
    
    func addContact() {
        let name = self.txtName.getText()
        let number = self.txtNumber.getText()
        if name.isEmpty() {
            self.showWarning("Please enter contact name")
            return
        }
        if number.isEmpty() {
            self.showWarning("Please enter contact number")
            return
        }
        
        let params: [String: Any] = [
            "name": name,
            "number": number,
            "avatar": avatarBase64
        ]
        
        self.showLoading(self)
        
        API.instance.addContact(params: params){ (response) in
            self.hideLoading()
            
            if response.error == nil {
                let noDataRes: NoDataRes = response.result.value!
                if noDataRes.success {
                    self.showSuccess(noDataRes.message)
                    
                    ContactListVC.instance.loadData()
                    self.onBack()
                } else {
                    self.showError(noDataRes.message)
                }
            }
        }
    }
    
    func updateContact() {
        let name = self.txtName.getText()
        let number = self.txtNumber.getText()
        if name.isEmpty() {
            self.showWarning("Please enter contact name")
            return
        }
        if number.isEmpty() {
            self.showWarning("Please enter contact number")
            return
        }
        
        let params: [String: Any] = [
            "id": currentContact!.id,
            "name": name,
            "number": number,
            "avatar": avatarBase64
        ]
        
        self.showLoading(self)
        
        API.instance.updateContact(params: params){ (response) in
            self.hideLoading()
            
            if response.error == nil {
                let noDataRes: NoDataRes = response.result.value!
                if noDataRes.success {
                    self.showSuccess(noDataRes.message)
                    
                    ContactListVC.instance.loadData()
                    self.onBack()
                } else {
                    self.showError(noDataRes.message)
                }
            }
        }
    }
}

extension ContactAddVC: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        if image != nil {
            self.avatarBase64 = image!.getBase64()
            self.imgAvatar.image = image
        } else {
            self.showWarning("This image can't use. Please select another one.")
        }
    }
}
