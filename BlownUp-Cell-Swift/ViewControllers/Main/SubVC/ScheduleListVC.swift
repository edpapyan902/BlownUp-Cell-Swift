//
//  ScheduleListVC.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 03/05/2021.
//

import Foundation
import UIKit

class ScheduleListVC: BaseVC {

    @IBOutlet weak var tblSchedule: UITableView!
    var refreshControl : UIRefreshControl!
    
    var m_Schedules = [Schedule]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        initLayout()
        
//        self.showLoading(self)
        
//        getData()
    }
    
    func initLayout() {
        self.setStatusBarStyle(true)
        
        self.tblSchedule.delegate = self
        self.tblSchedule.dataSource = self
        self.tblSchedule.backgroundColor = UIColor.clear
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.backgroundColor = UIColor.clear
        self.refreshControl.tintColor = UIColor.white

        self.refreshControl.addTarget(self, action: #selector(onRefresh(_:)), for: UIControl.Event.valueChanged)

        self.tblSchedule.addSubview(self.refreshControl)
    }
    
    @objc func onRefresh(_ refreshControl: UIRefreshControl) {
        self.refreshControl?.beginRefreshing()
        getData()
    }
    
    func getData() {
        self.m_Schedules.removeAll()
        self.tblSchedule.reloadData()
        
        API.instance.getAllSchedule() {(response) in
            self.hideLoading()
            self.refreshControl?.endRefreshing()
            
            if response.error == nil {
                let scheduleAllRes: ScheduleAllRes = response.result.value!
                
                if scheduleAllRes.success {
                    self.m_Schedules = scheduleAllRes.data.schedules!
                    if self.m_Schedules.count > 0 {
                        self.tblSchedule.reloadData()
                    }
                }
            }
        }
    }
}

class ScheduleTableViewCell: UITableViewCell {
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
}

extension ScheduleListVC: UITableViewDataSource, UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.m_Schedules.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleItemID", for: indexPath) as! ScheduleTableViewCell
        let rowIndex = indexPath.row
        let schedule = self.m_Schedules[rowIndex]
        
        let dateResult = schedule.scheduled_at.splite(" ")
        let timeResult = dateResult[1].splite(":")
        
        cell.lblNumber.text = schedule.contact != nil ? schedule.contact?.number : schedule.number
        cell.lblTime.text = dateResult[0]
        cell.lblDate.text = timeResult[0] + ":" + timeResult[1]
        
        cell.backgroundColor = UIColor.clear
        cell.isOpaque = false
        
        return cell
    }
}


