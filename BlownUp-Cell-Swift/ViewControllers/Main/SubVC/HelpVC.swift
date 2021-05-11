//
//  HelpVC.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 03/05/2021.
//

import Foundation
import UIKit
import AVFoundation
import AVKit

class HelpVC: BaseVC {

    @IBOutlet weak var tblHelp: UITableView!
    @IBOutlet weak var videoView: UIView!
    
    var m_Helps = [Help]()
    
    var video_url = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initLayout()
        
        initData()
    }
    
    func initLayout() {
        self.tblHelp.delegate = self
        self.tblHelp.dataSource = self
        self.tblHelp.backgroundColor = UIColor.clear
    }
 
    func playVideo() {
        guard let url = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_adv_example_hevc/master.m3u8") else {
                return
            }
            // Create an AVPlayer, passing it the HTTP Live Streaming URL.
            let player = AVPlayer(url: url)

            // Create a new AVPlayerViewController and pass it a reference to the player.
            let controller = AVPlayerViewController()
            controller.player = player

            // Modally present the player and call the player's play() method when complete.
            present(controller, animated: true) {
                player.play()
            }
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
                    self.m_Helps = helpRes.data.helps!
                    
                    if self.m_Helps.count > 0 {
                        
                        self.video_url = self.m_Helps[0].content
                        
                        self.m_Helps.remove(at: 0)
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
