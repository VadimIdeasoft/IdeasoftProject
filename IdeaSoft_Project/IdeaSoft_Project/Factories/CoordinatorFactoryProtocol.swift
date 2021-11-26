//
//  CoordinatorFactoryProtocol.swift
//  IdeaSoft_Project
//
//  Created by IdeaSoft on 26.11.2021.
//

import UIKit
protocol CoordinatorFactoryProtocol {
    func makeTabbarCoordinator() -> CoordinatorType & TabbarCoordinatorOutput
}
