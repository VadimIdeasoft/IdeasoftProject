//
//  CoordinatorFactory.swift
//  IdeaSoft_Project
//
//  Created by IdeaSoft on 26.11.2021.
//

import UIKit

final class CoordinatorFactory {
    private let modulesFactory = ModulesFactory()
}

// MARK: - CoordinatorFactoryProtocol
extension CoordinatorFactory: CoordinatorFactoryProtocol {
    func makeTabbarCoordinator() -> CoordinatorType & TabbarCoordinatorOutput {
        #warning("set items here")
        let vc = TabbarViewController.instantiate(with: [.one, .two, .three] )
        let module = TabbarAssembly.assembly(with: vc)
        
        let coordinator = TabbarCoordinator(tabbarView: module,
                                            factory: modulesFactory,
                                            coordinatorFactory: self)
        
        module.onDeinit = { [weak coordinator] in
            coordinator?.removeAllCoordinators()
        }
        
        return coordinator
    }
    
    func makeTestCoordinator(router: RouterType, with color: UIColor) -> CoordinatorType {
        let coordinator = TestCoordinator(router: router, factory: modulesFactory, coordinatorFactory: self, color: color)
        return coordinator
    }
}
    
// MARK: - Private methods
extension CoordinatorFactory {
    func router(_ navController: UINavigationController?) -> Router {
        return Router(navigationController: navigationController(navController))
    }
    
    func router(_ navController: UINavigationController?, in storyboard: Storyboards) -> RouterType {
        return Router(navigationController: navigationController(navController, in: storyboard))
    }
    
    func navigationController(_ navController: UINavigationController?, in storyboard: Storyboards) -> UINavigationController {
        return navController == nil ? UINavigationController.controllerFromStoryboard(storyboard) : navController!
    }
    
    func navigationController(_ navController: UINavigationController?) -> UINavigationController {
        if let navController = navController {
            return navController
        } else {
            let navigation = UINavigationController()
            return navigation
        }
    }
}
