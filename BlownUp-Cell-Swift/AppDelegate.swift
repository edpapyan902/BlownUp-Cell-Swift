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
import UserNotifications
import CallKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let notificationCenter = UNUserNotificationCenter.current()
    
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
        
        //  Notification Permission
        notificationCenter.delegate = self
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) {
            (granted, error) in
            if granted {
                DispatchQueue.main.async(execute: {
                    application.registerForRemoteNotifications()
                })
            }
            else {
                print("Notification permission denied")
            }
        }
        
        return true
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

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        handleIncomingCall()
        
        //  Cancel Scheduled Call
        var identifiers = [String]()
        identifiers.append(notification.request.identifier)
        cancelNotifications(identifiers: identifiers)
        
        completionHandler([.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        handleIncomingCall()
        
        //  Cancel Scheduled Call
        var identifiers = [String]()
        identifiers.append(response.notification.request.identifier)
        cancelNotifications(identifiers: identifiers)
        
        completionHandler()
    }
    
    func defaultConfig() -> CXProviderConfiguration {
        let config = CXProviderConfiguration()
        config.includesCallsInRecents = true
        config.supportsVideo = false
        config.maximumCallGroups = 1
        config.maximumCallsPerCallGroup = 1
        config.iconTemplateImageData = UIImage(named: "logo_green")!.pngData()

        return config
    }
    
    func handleIncomingCall() {
        let provider = CXProvider(configuration: self.defaultConfig())
        provider.setDelegate(self, queue: nil)
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .generic, value: "BlownUp")
        update.hasVideo = false
        provider.reportNewIncomingCall(with: UUID(), update: update, completion: { error in })
    }
    
    func scheduleIncomingCall(_ schedule: Schedule) {
        let trigger = UNCalendarNotificationTrigger(dateMatching: schedule.scheduled_at.TimeStamp2DateComponents(), repeats: false)

        let content = UNMutableNotificationContent()
        content.title = "Incoming Call"
        content.body = (schedule.contact == nil ? schedule.number : schedule.contact?.number)!
        content.sound = UNNotificationSound.default

        let request = UNNotificationRequest(identifier: schedule.alarm_identify, content: content, trigger: trigger)

        notificationCenter.delegate = self
        notificationCenter.add(request) {(error) in
            if let error = error {
                print("Notify set error: \(error)")
            }
        }
    }

    func cancelNotifications(identifiers: [String]) {
        notificationCenter.removeDeliveredNotifications(withIdentifiers: identifiers)
        notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}

extension AppDelegate : CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
        
    }
    
    private func provider( provider: CXProvider, perform action: CXAnswerCallAction) {
        action.fulfill()
    }

    private func provider( provider: CXProvider, perform action: CXEndCallAction) {
        action.fulfill()
    }

    private func provider( provider: CXProvider, perform action: CXStartCallAction) {

    }

    private func provider( provider: CXProvider, perform action: CXSetHeldCallAction) {

    }

    private func provider( provider: CXProvider, timedOutPerforming action: CXAction) {

    }

    private func provider( provider: CXProvider, perform action: CXPlayDTMFCallAction) {

    }

    private func provider( provider: CXProvider, perform action: CXSetGroupCallAction) {

    }

    private func provider( provider: CXProvider, perform action: CXSetMutedCallAction) {

    }
}
