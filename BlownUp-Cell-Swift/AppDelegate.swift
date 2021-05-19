//
//  AppDelegate.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 27/04/2021.
//

import UIKit
import IQKeyboardManagerSwift
import Stripe
import AVFoundation
import CallKit
import PushKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //  Keyboard avoid
        IQKeyboardManager.shared.enable = true
        //  Stripe Init
        StripeAPI.defaultPublishableKey = STRIPE_KEY
        
        //  AVAudioSession setting
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .moviePlayback, options: [])
        } catch {
            print("Failed to set audio session category.")
        }
        
        self.voipRegistration()
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        // [END register_for_notifications]
        
        return true
    }
    
    // Register for VoIP notifications
    func voipRegistration() {
        let mainQueue = DispatchQueue.main
        let voipRegistry: PKPushRegistry = PKPushRegistry(queue: mainQueue)
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [PKPushType.voIP]
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    //Rotate Restrict
    var restrictRotation:UIInterfaceOrientationMask = .portrait
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.restrictRotation
    }
}

extension AppDelegate: PKPushRegistryDelegate {
    
    func pushRegistry( registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        
        if type == PKPushType.voIP {
            let tokenParts = pushCredentials.token.map { data -> String in
                return String(format: "%02.2hhx", data)
            }
            
            let tokenString = tokenParts.joined()
            
            print("voidToken", tokenString)
            
            Store.instance.voipToken = tokenString
        }
    }
    
    func pushRegistry( registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        
    }
    
    func pushRegistry( registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type:PKPushType, completion: @escaping () -> Void) {
        
        if type == PKPushType.voIP {
            self.incomingCall()
        }
    }
    
    func pushRegistry( registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
        if type == PKPushType.voIP {
            self.incomingCall()
        }
    }
    
    func incomingCall() {
        let provider = CXProvider(configuration: defaultConfig())
        provider.setDelegate(self, queue: nil)
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .generic, value: "Test Caller")
        update.hasVideo = true
        provider.reportNewIncomingCall(with: UUID(), update: update, completion: { error in })
    }
    
    func defaultConfig() -> CXProviderConfiguration {
        let config = CXProviderConfiguration(localizedName: "BlownUp")
        config.includesCallsInRecents = true
        config.supportsVideo = false
        config.iconTemplateImageData = UIImagePNGRepresentation(UIImage(named: "logo_green")!)
        config.ringtoneSound = "Ringtone.aif"
        
        return config
    }
}

extension AppDelegate : CXProviderDelegate {
    
    func providerDidReset( provider: CXProvider) {
        
    }
    
    func providerDidBegin( provider: CXProvider) {
        
    }
    
    func provider( provider: CXProvider, perform action: CXAnswerCallAction) {
        action.fulfill()
    }
    
    func provider( provider: CXProvider, perform action: CXEndCallAction) {
        action.fulfill()
    }
    
    func provider( provider: CXProvider, perform action: CXStartCallAction) {
        
    }
    
    func provider( provider: CXProvider, perform action: CXSetHeldCallAction) {
        
    }
    
    func provider( provider: CXProvider, timedOutPerforming action: CXAction) {
        
    }
    
    func provider( provider: CXProvider, perform action: CXPlayDTMFCallAction) {
        
    }
    
    func provider( provider: CXProvider, perform action: CXSetGroupCallAction) {
        
    }
    
    func provider( provider: CXProvider, perform action: CXSetMutedCallAction) {
        
    }
}
