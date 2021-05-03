//
//  SettingVC.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 03/05/2021.
//

import Foundation
import UIKit

class SettingVC: BaseVC {

    @IBOutlet weak var tblInvoice: UITableView!
    @IBOutlet weak var lblRenew: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    var m_Invoices = [Invoice]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tblInvoice.delegate = self
        self.tblInvoice.dataSource = self
        self.tblInvoice.reloadData()
        self.tblInvoice.backgroundColor = UIColor.clear
        
        initData()
    }
    
    func initData() {
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
    
    @IBAction func cancelresumeSubscription(_ sender: Any) {
    }
    
    @IBAction func downloadPdf(_ sender: UIButton) {
        let invoice = self.m_Invoices[sender.tag]
        downloadPdf(url: invoice.invoice_pdf)
    }
    
    func downloadPdf(url: String) {
        
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
        let invoice = self.m_Invoices[indexPath.row]
        
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
