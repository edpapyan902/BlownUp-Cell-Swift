//
//  DialogContactVC.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 08/05/2021.
//

import Foundation
import UIKit

class DialogContactVC: BaseVC {
    
    @IBOutlet weak var tblContact: UITableView!
    var refreshControl : UIRefreshControl!

    var m_Contacts = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initLayout()
        
        self.showLoading(self)
        
        initData()
    }
    
    func initLayout() {
        self.tblContact.delegate = self
        self.tblContact.dataSource = self
        self.tblContact.backgroundColor = UIColor.clear
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.backgroundColor = UIColor.clear
        self.refreshControl.tintColor = UIColor.init(named: "colorPrimary")

        self.refreshControl.addTarget(self, action: #selector(onRefresh(_:)), for: UIControl.Event.valueChanged)

        self.tblContact.addSubview(self.refreshControl)
    }
    
    @objc func onRefresh(_ refreshControl: UIRefreshControl) {
        self.refreshControl?.beginRefreshing()
        initData()
    }
    
    func initData() {
        self.m_Contacts.removeAll()
        self.tblContact.reloadData()
        
        API.instance.getAllContact() {(response) in
            self.hideLoading()
            self.refreshControl?.endRefreshing()
            
            if response.error == nil {
                let contactAllRes: ContactAllRes = response.result.value!
                
                if contactAllRes.success {
                    self.m_Contacts = contactAllRes.data.contacts!
                    
                    if self.m_Contacts.count > 0 {
                        self.tblContact.reloadData()
                    }
                }
            }
        }
    }
    
    @objc func onCellClicked(_ sender: UITapGestureRecognizer) {
        if let cell = sender.view as? ContactTableViewCell {
            ScheduleAddVC.getInstance().setContact(self.m_Contacts[cell.tag])
            self.dismiss(animated: true, completion: nil)
        }
    }
}

class ContactTableViewCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
}

extension DialogContactVC: UITableViewDataSource, UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.m_Contacts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactItemID", for: indexPath) as! ContactTableViewCell
        let rowIndex = indexPath.row
        let contact = self.m_Contacts[rowIndex]
        
        cell.lblName.text = contact.name
        cell.lblNumber.text = contact.number
        cell.avatarView.makeRounded(40)
        
        cell.loader.isHidden = false
        cell.imgAvatar.isHidden = true
        
        getImageFromUrl(imageView: cell.imgAvatar, photoUrl: BASE_SERVER + contact.avatar) { (image) in
            if image != nil {
                cell.imgAvatar.image = image
                cell.imgAvatar.isHidden = false
                cell.loader.isHidden = true
            }
        }
        
        cell.backgroundColor = UIColor.clear
        cell.isOpaque = false
        
        print(rowIndex)
        cell.tag = rowIndex
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onCellClicked(_:))))
        
        return cell
    }
}