//
//  ApplicationCoordinator.swift
//  IdeaSoft_Project
//
//  Created by IdeaSoft on 26.11.2021.
//

import Foundation

protocol DeepLinkHandleable {
    func handle(deepLink option: DeepLinkOption)
}

final class ApplicationCoordinator: BaseCoordinator, ErrorReporter, ZoomModeChecker {
    
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private(set) var router : RouterType
    private(set) var alertTitle: String? = NSLocalizedString("Launch", comment: "")
    private let moduleFactory : ApplicationFactoryProtocol
    private var selectedRouter: RouterType?
    private var showLogo = true
    private var shouldCheckZoomMode = true
    
    init(router: RouterType, moduleFactory: ApplicationFactoryProtocol, coordinatorFactory: CoordinatorFactory) {
        self.router  = router
        self.coordinatorFactory = coordinatorFactory
        self.moduleFactory = moduleFactory
        
        super.init()
    }
    
}

// MARK:- Coordinatable
extension ApplicationCoordinator: CoordinatorType {
    func start() {
        removeAllCoordinators()
        showLogo = true
        start(with: nil)
    }
    
    func start(showLogo: Bool) {
        self.showLogo = showLogo
        start(with: nil)
    }
    
    func reload() {
        for coordinator in childCoordinators  {
            guard let coordinator = coordinator as? Reloadable else { continue }
            coordinator.reload(onCompletion: nil)
        }
        
    }
    
    func start(with option: DeepLinkOption?) {
        
        if let option = option, let coordinator = childCoordinators.first(where: { $0 is DeepLinkHandleable }) {
            (coordinator as? DeepLinkHandleable)?.handle(deepLink: option)
        } else {
            runMainFlow(option: option)
        }
    }
}

private extension ApplicationCoordinator {
    func runMainFlow(option: DeepLinkOption?) {
        let coordinator = coordinatorFactory.makeTabbarCoordinator()
        coordinator.finishFlow = { [unowned self, unowned coordinator] in
            self.start()
            self.removeDependency(coordinator)
        }
        addDependency(coordinator)
        
        router.setRootModule(coordinator, hideBar: true, animated: false)
        coordinator.start(with: option)
    }
}
