//
//  VoipCallManager.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 19/05/2021.
//

import Foundation
import UIKit
import CallKit
import PushKit

class VoipCallManager: NSObject, UNUserNotificationCenterDelegate {
    
    static let shared: VoipCallManager = VoipCallManager()
    
    private var provider: CXProvider?
    
    private let voipRegistry = PKPushRegistry(queue: nil)
    
    private override init() {
        super.init()
    }
    
    public func configureCall() {
        self.registerForRemoteNotification()
        self.configureProvider()
        self.configurePushKit()
    }
    
    private func registerForRemoteNotification() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    private func configureProvider() {
        let config = CXProviderConfiguration()
        config.supportsVideo = false
        config.supportedHandleTypes = [.generic, .phoneNumber]
        config.iconTemplateImageData = UIImage(named: "logo_green")!.pngData()
        config.ringtoneSound = "Ringtone.aif"
        
        provider = CXProvider(configuration: config)
        provider?.setDelegate(self, queue: DispatchQueue.main)
    }
    
    private func configurePushKit() {
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [.voIP]
    }
    
    public func incommingCall(name: String) {
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .generic, value: name)
        
        let bgTaskID = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.provider?.reportNewIncomingCall(with: UUID(), update: update, completion: { (_) in })
            UIApplication.shared.endBackgroundTask(bgTaskID)
        }
    }
    
    public func incommingCall(phoneNumber: String) {
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .phoneNumber, value: phoneNumber)
        
        let bgTaskID = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.provider?.reportNewIncomingCall(with: UUID(), update: update, completion: { (_) in })
            UIApplication.shared.endBackgroundTask(bgTaskID)
        }
    }
}

extension VoipCallManager: CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        action.fulfill()
    }
}

extension VoipCallManager: PKPushRegistryDelegate {
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        let parts = pushCredentials.token.map { String(format: "%02.2hhx", $0) }
        let token = parts.joined()
        
        Store.instance.voipToken = token
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        if type == .voIP {
            if let callData = payload.dictionaryPayload as? [String : Any], let name = callData["name"] as? String, let phoneNumber = callData["phoneNumber"] as? String {
                if name.isEmpty() {
                    self.incommingCall(phoneNumber: phoneNumber)
                } else {
                    self.incommingCall(name: name)
                }
            }
        }
    }
}
