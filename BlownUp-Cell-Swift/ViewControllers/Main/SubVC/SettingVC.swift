//
//  SettingVC.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 03/05/2021.
//

import Foundation
import UIKit
import SDDownloadManager
import PDFReader

class SettingVC: BaseVC {

    @IBOutlet weak var btnCancelSubscription: UIButton!
    @IBOutlet weak var tblInvoice: UITableView!
    @IBOutlet weak var lblRenew: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    var m_Invoices = [Invoice]()
    
    let APP_INVOICE_DIR: URL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!.appendingPathComponent("BlownUp/Invoices")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tblInvoice.delegate = self
        self.tblInvoice.dataSource = self
        self.tblInvoice.reloadData()
        self.tblInvoice.backgroundColor = UIColor.clear
        
        checkSubscriptionStatus()
        initHistoryData()
    }
    
    func initHistoryData() {
        self.showLoading(self)
        
        API.instance.getBillingHistory() { (response) in
            self.hideLoading()
            
            if response.error == nil {
                let invoiceRes: InvoiceRes = response.result.value!
                
                if invoiceRes.success! {
                    self.m_Invoices = (invoiceRes.data?.invoices?.data)!
                    self.tblInvoice.reloadData()
                } else {
                    self.showError(invoiceRes.message!)
                }
            }
        }
    }
    
    func checkSubscriptionStatus() {
        if Store.instance.isSubscriptionCancelled {
            self.lblDescription.text = "Your Subscription Ended On:"
            self.btnCancelSubscription.setTitle("RESUME SUBSCRIPTION", for: .normal)
            let endDay = (Date().int2date(milliseconds: Store.instance.subscriptionUpcomingDate)).addDay(-1)
            self.lblRenew.text = endDay.toString("MM.dd.yyyy")
        } else {
            self.lblDescription.text = "Your Subscription Renews On:"
            self.btnCancelSubscription.setTitle("CANCEL SUBSCRIPTION", for: .normal)
            self.lblRenew.text = (Date().int2date(milliseconds: Store.instance.subscriptionUpcomingDate)).toString("MM.dd.yyyy")
        }
    }
    
    @IBAction func cancelresumeSubscription(_ sender: Any) {
        if (Store.instance.isSubscriptionCancelled) {
            resumeSubscription()
        } else {
            cancelSubscription()
        }
    }
    
    func resumeSubscription() {
        self.showLoading(self)
        
        API.instance.resumeSubscription() {(response) in
            self.hideLoading()
            
            if response.error == nil {
                let subscriptionRes: SubscriptionRes = response.result.value!
                
                if subscriptionRes.success! {
                    let data = subscriptionRes.data
                    
                    if !((data?.is_ended)!) && !((data?.is_cancelled)!) {
                        Store.instance.subscriptionUpcomingDate = (data?.upcoming_invoice)!
                    }
                    Store.instance.isSubscriptionEnded = (data?.is_ended)!
                    Store.instance.isSubscriptionCancelled = (data?.is_cancelled)!
                    
                    self.checkSubscriptionStatus()
                    
                    if Store.instance.isSubscriptionEnded {
                        self.gotoVC("CardRegisterVC")
                    }
                }
            }
        }
    }
    
    func cancelSubscription() {
        self.showLoading(self)
        
        API.instance.cancelSubscription() {(response) in
            self.hideLoading()
            
            if response.error == nil {
                let subscriptionRes: SubscriptionRes = response.result.value!
                
                if subscriptionRes.success! {
                    let data = subscriptionRes.data
                    
                    if !((data?.is_ended)!) && !((data?.is_cancelled)!) {
                        Store.instance.subscriptionUpcomingDate = (data?.upcoming_invoice)!
                    }
                    Store.instance.isSubscriptionEnded = (data?.is_ended)!
                    Store.instance.isSubscriptionCancelled = (data?.is_cancelled)!
                    
                    self.checkSubscriptionStatus()
                    
                    if Store.instance.isSubscriptionEnded {
                        self.gotoVC("CardRegisterVC")
                    }
                }
            }
        }
    }
    
    @IBAction func downloadPdf(_ sender: UIButton) {
        let invoice = self.m_Invoices[sender.tag]
        let invoice_file_url = (invoice.local_file_path?.path)!
        if existFile(invoice_file_url) {
            let document = PDFDocument(url: invoice.local_file_path!)!
            let readerController = PDFViewController.createNew(with: document)
            self.present(readerController, animated: false, completion: nil)
        } else {
            sender.isHidden = true
            SDDownloadManager.shared.downloadFile(withRequest: URLRequest(url:URL(string: invoice.invoice_pdf)!), inDirectory: APP_INVOICE_DIR.path, withName: invoice.file_name!, shouldDownloadInBackground: true, onProgress: nil) {(error, filepath) in
                sender.isHidden = false
                if error == nil {
                    if !FileManager.default.fileExists(atPath: self.APP_INVOICE_DIR.path) {
                        do {
                            try FileManager.default.createDirectory(at: self.APP_INVOICE_DIR, withIntermediateDirectories: true, attributes: nil)
                        } catch  {
                            return
                        }
                    }
                    
                    do {
                        try FileManager.default.moveItem(at: filepath!, to: invoice.local_file_path!)
                        sender.setBackgroundImage(UIImage.init(named: "ic_pdf_open"), for: .normal)
                    } catch {
                        print("file move error")
                    }
                }
                else {
                    print("download error", error)
                }
            }
        }
    }
    
    func existFile(_ name: String)-> Bool {
        return FileManager.default.fileExists(atPath: name)
    }
}

class InvoiceTableViewCell: UITableViewCell {
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var lblDate: UILabel!
}

extension SettingVC: UITableViewDataSource, UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.m_Invoices.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceItemID", for: indexPath) as! InvoiceTableViewCell
        let rowIndex = indexPath.row
        
        self.m_Invoices[rowIndex].file_name = self.m_Invoices[rowIndex].number + ".pdf"
        self.m_Invoices[rowIndex].local_file_path = APP_INVOICE_DIR.appendingPathComponent(self.m_Invoices[rowIndex].file_name!)
        
        let invoice = self.m_Invoices[rowIndex]
        
        if self.existFile(invoice.local_file_path!.path) {
            cell.btnDownload.setBackgroundImage(UIImage.init(named: "ic_pdf_open"), for: .normal)
        }
        
        cell.btnDownload.tag = indexPath.row
        cell.lblDate.text = (Date().int2date(milliseconds: invoice.created)).toString("MM.dd.yyyy")
        cell.lblTotal.text = "$ \(Double(invoice.total) / 100)"
        
        switch invoice.status {
        case "draft":
            cell.btnStatus.setTitle("Draft", for: .normal)
            cell.btnStatus.backgroundColor = UIColor.init(named: "colorDraft")
            break
        case "paid":
            cell.btnStatus.setTitle("Paid", for: .normal)
            cell.btnStatus.backgroundColor = UIColor.init(named: "colorPaid")
            break
        case "delete":
            cell.btnStatus.setTitle("Delete", for: .normal)
            cell.btnStatus.backgroundColor = UIColor.init(named: "colorDelete")
            break
        case "void":
            cell.btnStatus.setTitle("Void", for: .normal)
            cell.btnStatus.backgroundColor = UIColor.init(named: "colorVoid")
            break
        case "uncollectible":
            cell.btnStatus.setTitle("Uncollectible", for: .normal)
            cell.btnStatus.backgroundColor = UIColor.init(named: "colorUncollectible")
            break
        default:
            break
        }
        
        cell.backgroundColor = UIColor.clear
        cell.isOpaque = false
        
        return cell
    }
}
