//
//  TabbarPresenter.swift
//  IdeaSoft_Project
//
//  Created by IdeaSoft on 26.11.2021.
//

import UIKit

protocol TabbarPresenterInput: AnyObject {
    func viewDidLoad()
    func viewDidAppear(_ animated: Bool)
    func report(about error: Error, title: String?)
    func didSelect(_ tabbarItem: TabbarItem, navController: UINavigationController)
}

protocol TabbarPresenterOutput: BasePresenterOutput {
    var presenter: TabbarPresenterInput? { get set }
    var currentNavigationController: UINavigationController? { get }
    func setSelect(_ tabbarItem: TabbarItem)
    var model: [TabbarItem]! { get }
}

final class TabbarPresenter: NSObject, TabbarModule {
    
    
    // Presentable
    var toPresent: UIViewController? { return output as? UIViewController }
    weak var output: TabbarPresenterOutput?
    var interactor: TabbarBusinessLogic?
    
    // Callbacks
    var onCompletion: CompletionBlock?
    var onError: ((Error, String?) -> Void)?
    
    var onViewDidLoad: CompletionBlock?
    var onViewDidAppear: CompletionBlock?
    var onDidSelectTabbarItem: ((TabbarItem, UINavigationController) -> Void)?

    var tabbarItemModels: [TabbarItem] {
        return output?.model ?? []
    }
    
    var onDeinit: CompletionBlock?
    
    
    override init() {
            super.init()
        }
        
        deinit {
            onDeinit?()
            printDeinit()
        }
    
}

// MARK:- TabbarPresenterInput
extension TabbarPresenter: TabbarPresenterInput {
    
    // MARK: Module life cycle
    func viewDidLoad() {

    }
    
    func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    // MARK: Input Actions
    func report(about error: Error, title: String?) {
        assert(onError != nil)
        onError?(error, title)
    }
    
    func didSelect(_ tabbarItem: TabbarItem, navController: UINavigationController) {
        onDidSelectTabbarItem?(tabbarItem, navController)
    }
    
    // MARK: Module Protocol
    func setSelect(_ tabbarItem: TabbarItem) {
        output?.setSelect(tabbarItem)
    }
    
    func currentNavitationController() -> UINavigationController? {
        return output?.currentNavigationController
    }

    func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        guard let tabbar = output as? UITabBarController else {
            assertionFailure()
            return
        }
        tabbar.setViewControllers(viewControllers, animated: animated)
    }
}
