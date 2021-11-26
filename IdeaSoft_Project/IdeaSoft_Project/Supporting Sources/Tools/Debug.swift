//
//  Debug.swift
//  IdeaSoft_Project
//
//  Created by IdeaSoft on 26.11.2021.
//

import UIKit

// https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/Strings/Articles/formatSpecifiers.html`

enum DebugLevel {
    case none
    case high
}

struct DebugOptions: OptionSet {
    let rawValue: Int
    
    static let info     = DebugOptions(rawValue: 1 << 0)
    static let `deinit` = DebugOptions(rawValue: 1 << 1)
    static let error    = DebugOptions(rawValue: 1 << 2)
    static let warning  = DebugOptions(rawValue: 1 << 3)
    static let response = DebugOptions(rawValue: 1 << 4)
    static let analytics = DebugOptions(rawValue: 1 << 5)
    
    static var shouldPrintAnalytics: Bool {
        #if DEBUG
        return debugOptions.contains(.analytics)
        #else
        return false
        #endif
        
    }
}

#if DEVELOPMENT && DEBUG
let debugOptions: DebugOptions = [ .info, .warning, .error, .deinit ]
#else
let debugOptions: DebugOptions = [ .error ]
#endif



func printInfo(file: String = #file, function: String = #function, message: String...) {
    guard debugOptions.contains(.info) else { return }
    
    let fileName: String = file.components(separatedBy: "/").last?.components(separatedBy: ".").first ?? ""
    let arguments: String
    if message.count > 0 {
        arguments = message.joined(separator: " ")
    } else {
        arguments = " "
    }
    let token = String(format: "👍 %@ : %@ %@", fileName, function, arguments)
    debugPrint(token)
}

func printDeinit(file: String = #file, function: String = #function) {
    guard debugOptions.contains(.deinit) else { return }
    let fileName: String = file.components(separatedBy: "/").last?.components(separatedBy: ".").first ?? ""
    let token = String(format: "🚀 %@ : %@", fileName, function)
    debugPrint(token)
}

func printError(file: String = #file, function: String = #function, error: Error) {
    guard debugOptions.contains(.error) else { return }
    let desc: String =  error.localizedDescription
    let fileName: String = file.components(separatedBy: "/").last?.components(separatedBy: ".").first ?? ""
    let token = String(format: "🚫 %@ : %@ %@", fileName, function, desc)
    debugPrint(token)
}

func printWarning(file: String = #file, function: String = #function, message: String) {
    guard debugOptions.contains(.warning) else { return }
    let fileName: String = file.components(separatedBy: "/").last?.components(separatedBy: ".").first ?? ""
    let token = String(format: "⚠️ %@ : %@ %@", fileName, function, message)
    debugPrint(token)
}

