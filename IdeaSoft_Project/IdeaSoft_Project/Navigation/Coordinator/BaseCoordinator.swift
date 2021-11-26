//
//  BaseCoordinator.swift
//  IdeaSoft_Project
//
//  Created by IdeaSoft on 26.11.2021.
//

import Foundation

class BaseCoordinator: NSObject {
    
    var childCoordinators: [CoordinatorType] = []
        
    override init() {
        super.init()
    }
    
    func addDependency(_ coordinator: CoordinatorType) {
        for element in childCoordinators {
            if element === coordinator { return }
        }
        childCoordinators.append(coordinator)
    }
    
    func removeDependency(_ coordinator: CoordinatorType?) {
        guard
            childCoordinators.isEmpty == false,
            let coordinator = coordinator
            else { return }
        
        for (index, element) in childCoordinators.enumerated() {
            if element === coordinator {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func removeAllCoordinators() {
        for coordinator in self.childCoordinators {
            coordinator.removeAllCoordinators()
            self.removeDependency(coordinator)
        }
    }
}

