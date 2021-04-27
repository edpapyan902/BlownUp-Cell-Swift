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
}
