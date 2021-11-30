//
//  Error+Extension.swift
//  IdeaSoft_Project
//
//  Created by IdeaSoft on 26.11.2021.
//

import Foundation

extension String: Error {}

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}

public extension NSError {
    
    static func error(title: String, code: Int) -> NSError {
        let bundleName =  Bundle.main.bundleIdentifier!
        return NSError(domain: bundleName, code: code, userInfo: [NSLocalizedDescriptionKey : title])
    }
    
    static func error(title: String) -> NSError {
        return error(title: title, code: 0)
    }
}


typealias ErrorCode = ErorType.ErrorCodes

public enum ErorType: Error {
    public enum ErrorCodes:Int, Equatable {
        case notFound = 500
        case userNotFound = 501
        case couldNotConnectToTheServer = -1004
        case noInternetConnection = -1009
        case requestTimeOut = -1001
    }
    
    case wrongSubclassing
    case requestError(Int, String)
    case parseError(message:String)
    case emptyData(message:String)
    case invalidIndexPath
    
}

extension Error {
    var code: ErrorCode {
        return ErrorCode(rawValue: (self as NSError).code) ?? ErrorCode.notFound
    }
    
    
}
