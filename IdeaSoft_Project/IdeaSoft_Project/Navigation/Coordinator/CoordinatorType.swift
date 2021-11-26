//
//  CoordinatorType.swift
//  IdeaSoft_Project
//
//  Created by IdeaSoft on 26.11.2021.
//

import Foundation

protocol CoordinatorType: AnyObject {
    func start()
    func start(with option: DeepLinkOption?)
    func removeAllCoordinators()
}

extension CoordinatorType {
    func start() {
        start(with: nil)
    }
    
    func start(with option: DeepLinkOption?) {
        assertionFailure()
    }
}
