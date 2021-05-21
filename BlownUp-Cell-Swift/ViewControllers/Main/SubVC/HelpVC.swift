//
//  HelpVC.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 03/05/2021.
//

import Foundation
import UIKit
import AVFoundation
import MediaPlayer
import AVKit

class HelpVC: BaseVC {
    
    static var instance: HelpVC? = nil
    
    @IBOutlet weak var imgScheduleAdd: UIImageView!
    @IBOutlet weak var tblHelp: UITableView!
    @IBOutlet weak var videoView: UIView!
    
    var m_Helps = [Help]()
    
    var avPlayer: AVPlayer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        HelpVC.instance = self
        
        initLayout()
        
        initData()
    }
    
    func initLayout() {
        self.tblHelp.delegate = self
        self.tblHelp.dataSource = self
        self.tblHelp.backgroundColor = UIColor.clear
        
        self.imgScheduleAdd.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onScheduleAddClicked)))
        
        self.videoView.makeRounded(10)
    }
    
    @objc func onScheduleAddClicked() {
        if avPlayer != nil {
            avPlayer!.pause()
        }
        self.gotoScheduleAddVC(nil)
    }
    
    func setHelpVideo(_ url: String) {
        avPlayer = AVPlayer(url: URL.init(string: url)!)
        let playerViewController = AVPlayerViewController()
        playerViewController.view.frame = self.videoView.bounds
        playerViewController.player = avPlayer
        self.addChild(playerViewController)
        self.videoView.addSubview(playerViewController.view)
        avPlayer!.pause()
    }
    
    func initData() {
        self.showLoading(self)
        
        self.m_Helps.removeAll()
        self.tblHelp.reloadData()
        
        API.instance.getAllHelp() {(response) in
            self.hideLoading()
            
            if response.error == nil {
                let helpRes: HelpRes = response.result.value!
                
                if helpRes.success {
                    let helps = helpRes.data.helps!
                    
                    if helps.count > 0 {
                        for help in helps {
                            if help.type == 1 {
                                self.m_Helps.append(help)
                            } else if help.type == 0 {
                                if !help.content.isEmpty() {
                                    let url = BASE_SERVER + help.content
                                    self.setHelpVideo(url.replace("\\", "/"))
                                }
                            }
                        }
                        
                        self.tblHelp.reloadData()
                    }
                }
            }
        }
    }
}

class HelpTableViewCell: UITableViewCell {
    @IBOutlet weak var lblDescription: UILabel!
}

extension HelpVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.m_Helps.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HelpItemID", for: indexPath) as! HelpTableViewCell
        let rowIndex = indexPath.row
        
        let help = self.m_Helps[rowIndex]
        
        cell.lblDescription.text = help.content
        
        cell.backgroundColor = UIColor.clear
        cell.isOpaque = false
        
        return cell
    }
}
