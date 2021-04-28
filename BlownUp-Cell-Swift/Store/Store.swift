//
//  Store.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 27/04/2021.
//

import Foundation

class Store {
    
    static let instance = Store()
    
    let defaults = UserDefaults.standard

    var apiToken: String {
        get {
            return defaults.value(forKey: API_TOKEN) as? String ?? ""
        }
        set {
            defaults.set(newValue, forKey: API_TOKEN)
        }
    }
    
    func getUser(key: String) -> User? {
        if let data = defaults.data(forKey: key) {
            do {
                let decoder = JSONDecoder()
                let user = try decoder.decode(User.self, from: data)
                return user
            } catch {
                print("Unable to Decode User Profile (\(error))")
                return nil
            }
        }
        return nil
    }
    
    func setUser(key: String, data: User) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(data)
            defaults.set(data, forKey: key)
        } catch {
            print("Unable to Encode User Profile (\(error))")
        }
    }
    
    func removeObject(key: String) {
        defaults.removeObject(forKey: key)
    }
    
    var rememberMe: Bool {
        get {
            return defaults.value(forKey: REMEMBER_ME) as? Bool ?? false
        }
        set {
            defaults.set(newValue, forKey: REMEMBER_ME)
        }
    }
    
    var subscriptionUpcomingDate: Int {
        get {
            return defaults.value(forKey: SUBSCRIPTION_UPCOMING_DATE) as? Int ?? 0
        }
        set {
            defaults.set(newValue, forKey: SUBSCRIPTION_UPCOMING_DATE)
        }
    }
    
    var isSubscriptionEnded: Bool {
        get {
            return defaults.value(forKey: IS_SUBSCRIPTION_ENDED) as? Bool ?? false
        }
        set {
            defaults.set(newValue, forKey: IS_SUBSCRIPTION_ENDED)
        }
    }
    
    var isSubscriptionCancelled: Bool {
        get {
            return defaults.value(forKey: IS_SUBSCRIPTION_CANCELLED) as? Bool ?? false
        }
        set {
            defaults.set(newValue, forKey: IS_SUBSCRIPTION_CANCELLED)
        }
    }
}
