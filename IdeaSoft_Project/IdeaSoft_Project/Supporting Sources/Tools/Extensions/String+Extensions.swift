//
//  String+Extensions.swift
//  IdeaSoft_Project
//
//  Created by IdeaSoft on 30.11.2021.
//

import UIKit

extension String {
    
    public var digits: String {
        return self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
    
    public func stringWithout(prefix: String) -> String {
        if self.isEmpty {
            return self
        }
        
        var str = self
        
        while str.hasPrefix(prefix) {
            str = String(str[prefix.endIndex...])
        }
        return str
    }
    
    public func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    
    public func removingWhiteSpacesAndNewlines() -> String {
        return components(separatedBy: .whitespacesAndNewlines).joined()
    }
    
    public func withoutSpacesInFront() -> String {
        var result: String
        if self.first == " " {
            result = String(self.dropFirst())
            return result.withoutSpacesInFront()
        } else {
            result = self
        }
        
        return result
    }
}

extension String {
    public var pairs: [String] {
        var result: [String] = []
        let characters = Array(self)
        stride(from: 0, to: count, by: 2).forEach {
            result.append(String(characters[$0..<min($0+2, count)]))
        }
        return result
    }
    
    public mutating func insert(separator: String, every n: Int) {
        self = inserting(separator: separator, every: n)
    }
    
    public func inserting(separator: String, every n: Int) -> String {
        var result: String = ""
        let characters = Array(self)
        stride(from: 0, to: count, by: n).forEach {
            result += String(characters[$0..<min($0+n, count)])
            if $0+n < count {
                result += separator
            }
        }
        return result
    }
}

extension String {
    public func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.dropFirst()
    }

    public mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}

