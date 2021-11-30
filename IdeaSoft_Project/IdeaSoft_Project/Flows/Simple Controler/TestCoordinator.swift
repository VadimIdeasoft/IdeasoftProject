//
//  TestCoordinator.swift
//  IdeaSoft_Project
//
//  Created by IdeaSoft on 30.11.2021.
//

import UIKit

final class TestCoordinator: BaseCoordinator, TestCoordinatorOutput, ErrorReporter {
    var toPresent: UIViewController? { router.toPresent }
    var finishFlow: CompletionBlock?
    
    private(set) var router: RouterType
    
    private let moduleFactory: TestFactoryProtocol
    private let coordinatorFactory: CoordinatorFactoryProtocol
    
    private(set) var alertTitle: String? = nil
    
    
    private(set) var childColor: UIColor
    
    init(router: RouterType, factory: TestFactoryProtocol, coordinatorFactory: CoordinatorFactoryProtocol, color: UIColor) {
        self.moduleFactory = factory
        self.coordinatorFactory = coordinatorFactory
        self.router = router
        self.childColor = color
        
        super.init()
    }
    
    deinit{
        printDeinit()
    }
}


// MARK: - CoordinatorType
extension TestCoordinator: CoordinatorType {
    func start() {
        let module = moduleFactory.makeFirstController(with: childColor)
        
        router.setRootModule(module)
    }
}
