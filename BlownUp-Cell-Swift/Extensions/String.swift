//
//  String.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 27/04/2021.
//

import Foundation

extension String {
    func isEmpty() -> Bool {
        return self == ""
    }
    
    func splite(_ separatedBy: String) -> [String] {
        return self.components(separatedBy: separatedBy)
    }
    
    func subString(_ start: Int, _ offset: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex = self.index(self.startIndex, offsetBy: (start + offset))
        let range = startIndex..<endIndex
        let result: String = String(self[range])
        return result
    }
    
    func isValidEmail() -> Bool {
        let REGEX: String
        REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: self)
    }
    
    func isValidePhone() -> Bool {
       let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
       let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
       return phoneTest.evaluate(with: self)
   }
}
