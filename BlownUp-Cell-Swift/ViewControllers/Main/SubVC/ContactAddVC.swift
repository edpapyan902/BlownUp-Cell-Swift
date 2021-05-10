//
//  ContactAddVC.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 03/05/2021.
//

import Foundation
import UIKit
import UIImageCropper

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
    }
    
    func initLayout() {
        self.avatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.pickImage)))
        self.imgContactAdd.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showContact)))
        
        self.avatarView.makeRounded(100)
    }
    
    @objc func showContact() {
        
    }
    
    @objc func pickImage() {
        let picker = UIImagePickerController()
        let cropper = UIImageCropper(cropRatio: 2/3)
        
        cropper.picker = picker
        cropper.delegate = self
        self.present(cropper, animated: true, completion: nil)
    }
    
    @IBAction func addupdateContact(_ sender: Any) {
    }
}

extension ContactAddVC: UIImageCropperProtocol {
    func didCropImage(originalImage: UIImage?, croppedImage: UIImage?) {
//        imageView.image = croppedImage
    }

    //optional (if not implemented cropper will close itself and picker)
    func didCancel() {
//        picker.dismiss(animated: true, completion: nil)
    }

}
