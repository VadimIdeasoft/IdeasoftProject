//
//  DeepLinkOption.swift
//  IdeaSoft_Project
//
//  Created by IdeaSoft on 26.11.2021.
//
import Foundation

enum DeepLinkOption {
    
    static func build(with userActivity: NSUserActivity) -> DeepLinkOption? {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let url = userActivity.webpageURL,
            let _ = URLComponents(url: url, resolvingAgainstBaseURL: true) {
        }
        return nil
    }
    
    static func build(with dict: JSON?) -> DeepLinkOption? {
        return nil
    }
}
