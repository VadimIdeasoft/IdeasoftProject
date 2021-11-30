//
//  TabbarCoordinator.swift
//  IdeaSoft_Project
//
//  Created by IdeaSoft on 26.11.2021.
//

import UIKit

final class TabbarCoordinator: BaseCoordinator, TabbarCoordinatorOutput, DeepLinkHandleable, Reloadable {
    var toPresent: UIViewController? { tabbarView.toPresent }
    var finishFlow: CompletionBlock?
    
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let moduleFactory : TabbarFactoryProtocol
    private weak var tabbarView: TabbarModule!
    private let tabbarItems: [TabbarItem]
    private var router: RouterType? {
        guard let vc = SceneDelegate.tabBarController?.selectedViewController as? UINavigationController else {
            assertionFailure()
            return nil
        }
        
        for router in routers where router.toPresent == vc {
            return router
        }
        let router = Router(navigationController: vc)
        routers.append(router)
        return router
    }
    
    
    private var deepLink: DeepLinkOption?
    
    private var currentRouter: RouterType?
    private var routers: [RouterType] = []
    
    private var tabs: [UIViewController: CoordinatorType] = [:]
  
    init(tabbarView: TabbarModule, factory: TabbarFactoryProtocol, coordinatorFactory: CoordinatorFactoryProtocol) {

        self.moduleFactory = factory
        self.coordinatorFactory = coordinatorFactory
        self.tabbarView = tabbarView
        #warning("place needed tabbar items here")
        let items: [TabbarItem] = [.one, .two, .three]
        self.tabbarItems = items
        
        super.init()
    }
    
    deinit {
        printDeinit()
    }
}

// MARK:- Coordinatable
extension TabbarCoordinator: CoordinatorType {
    
    func reload(onCompletion: CompletionBlock?) {
        
    }

    
    func start(with option: DeepLinkOption?) {
        self.deepLink = option
        
        tabbarView.onViewDidLoad = { [unowned self] in
            
            for tabItem in self.tabbarItems {
                let router: RouterType
                switch tabItem {
                    #warning("create child coordinator here and place as router, then pass it to routers")
                case .one:
                    router = createFirstCoordinator(with: nil, color: .red)
                    debugPrint("first coordinator")
                case .two:
                    router = createFirstCoordinator(with: nil, color: .blue)
                    debugPrint("second coordinator")
                case .three:
                    router = createFirstCoordinator(with: nil, color: .green)
                    debugPrint("third coordinator")
                }
                
                tabItem.customizeTabbarItem(of: router.toPresent)
                self.routers.append(router)
                
            }
            
            
            let vcs = self.routers.compactMap{ $0.toPresent }
            self.tabbarView.setViewControllers(vcs, animated: true)
            
            self.tabbarView.setSelect(.one)
        }
        
        tabbarView.onViewDidAppear = { [unowned self] in
            guard let option = option else {
                return
            }
            self.process(deepLink: option)
        }
    }
    
    private func process(deepLink option: DeepLinkOption) {
        switch option {
            
        }
        
        self.deepLink = nil
    }
    
    func handle(deepLink option: DeepLinkOption) {
        process(deepLink: option)
    }
}

// MARK: - Coordinators creation
extension TabbarCoordinator {
    private func createFirstCoordinator(with router: RouterType? = nil, color: UIColor) -> RouterType {
        let router = router ?? Router(navigationController: UINavigationController())
        let coordinator = coordinatorFactory.makeTestCoordinator(router: router, with: color)
        
        addDependency(coordinator)
        coordinator.start()
        
        return router
    }
}
