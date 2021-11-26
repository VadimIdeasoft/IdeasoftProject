//
//  ModulesFactory.swift
//  IdeaSoft_Project
//
//  Created by IdeaSoft on 26.11.2021.
//

import UIKit

final class ModulesFactory {}

// MARK:- Private methods
private extension ModulesFactory {
    func router(_ navController: UINavigationController?, in storyboard: Storyboards) -> RouterType {
        return Router(navigationController: navigationController(navController, in: storyboard))
    }
    
    func navigationController(_ navController: UINavigationController?, in storyboard: Storyboards) -> UINavigationController {
        return navController == nil ? UINavigationController.controllerFromStoryboard(storyboard) : navController!
    }
}


extension ModulesFactory: TabbarFactoryProtocol {}
