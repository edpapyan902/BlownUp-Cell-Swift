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
}
