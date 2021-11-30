//
//  ServiceLocator.swift
//  IdeaSoft_Project
//
//  Created by IdeaSoft on 30.11.2021.
//

import Foundation

protocol ServiceLocatorType {
    
}

final class ServiceLocator: ServiceLocatorType {
    let shared: ServiceLocator = ServiceLocator()
}
