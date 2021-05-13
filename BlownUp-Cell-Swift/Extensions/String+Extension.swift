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
        if self.isEmpty() {
            return false
        }
        
        let REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: self)
    }
    
    func isValidePhone() -> Bool {
        if self.isEmpty() {
            return false
        }
        
        let phonePattern = #"^\(?\d{3}\)?[ -]?\d{3}[ -]?\d{4}$"#
        let result = self.range(
            of: phonePattern,
            options: .regularExpression
        )

        return result != nil
    }
    
    func replace(_ to: String, _ by: String) -> String {
        return self.replacingOccurrences(of: to, with: by)
    }
    
    func toUSDateFormat() -> String {
        let result = self.splite("-")
        return result[1] + "/" + result[2] + "/" + result[0]
    }
}
