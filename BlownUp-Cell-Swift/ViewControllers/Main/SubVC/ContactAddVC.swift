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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initLayout()
    }
    
    func initLayout() {
        self.imgAvatar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.pickImage)))
        self.imgContactAdd.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showContact)))
        
        self.avatarView.makeRounded(100)
    }
    
    @objc func showContact() {
        
    }
    
    @objc func pickImage() {
        
    }
    
    @IBAction func addupdateContact(_ sender: Any) {
    }
}
