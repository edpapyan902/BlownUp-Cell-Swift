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

class VoipCallManager: NSObject {
    
    static let shared: VoipCallManager = VoipCallManager()
    
    private var provider: CXProvider?
    
    private let voipRegistry = PKPushRegistry(queue: nil)
    
    private override init() {
        super.init()
        self.configureProvider()
    }
    
    private func configureProvider() {
        let config = CXProviderConfiguration(localizedName: "BlownUp Call")
        config.supportsVideo = false
        config.supportedHandleTypes = [.generic]
        config.iconTemplateImageData = UIImage(named: "logo_green")!.pngData()
        config.ringtoneSound = "Ringtone.aif"
        
        provider = CXProvider(configuration: config)
        provider?.setDelegate(self, queue: DispatchQueue.main)
    }
    
    public func configurePushKit() {
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [.voIP]
    }
    
    public func incommingCall(from: String) {
        incommingCall(from: from, delay: 0)
    }
    
    public func incommingCall(from: String, delay: TimeInterval) {
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .generic, value: from)
        
        let bgTaskID = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            self.provider?.reportNewIncomingCall(with: UUID(), update: update, completion: { (_) in })
            UIApplication.shared.endBackgroundTask(bgTaskID)
        }
    }
    
    public func outgoingCall(from: String, connectAfter: TimeInterval) {
        let controller = CXCallController()
        let fromHandle = CXHandle(type: .generic, value: from)
        let startCallAction = CXStartCallAction(call: UUID(), handle: fromHandle)
        startCallAction.isVideo = true
        let startCallTransaction = CXTransaction(action: startCallAction)
        controller.request(startCallTransaction) { (error) in }
        
        self.provider?.reportOutgoingCall(with: startCallAction.callUUID, startedConnectingAt: nil)
        
        let bgTaskID = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + connectAfter) {
            self.provider?.reportOutgoingCall(with: startCallAction.callUUID, connectedAt: nil)
            UIApplication.shared.endBackgroundTask(bgTaskID)
        }
    }
}

extension VoipCallManager: CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
        print("provider did reset")
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        print("call answered")
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        print("call ended")
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        print("call started")
        action.fulfill()
    }
}

extension VoipCallManager: PKPushRegistryDelegate {
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        let parts = pushCredentials.token.map { String(format: "%02.2hhx", $0) }
        let token = parts.joined()
        print("did update push credentials with token: \(token)")
        
        Store.instance.voipToken = token
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        if type == .voIP {
            self.incommingCall(from: "Test Caller")
        }
//        if let callerID = payload.dictionaryPayload["callerID"] as? String {
//            self.incommingCall(from: callerID)
//        }
    }
}
