//
//  TabbarViewController.swift
//  IdeaSoft_Project
//
//  Created by IdeaSoft on 26.11.2021.
//

import UIKit

final class TabbarViewController: UITabBarController, UITabBarControllerDelegate, TabbarPresenterOutput {
    
    
    private var models: [TabbarItem] = []
    
    
    var onCompletion: CompletionBlock?
    var onError: ((Error, String?) -> Void)?
    var presenter: TabbarPresenterInput?
    
    var currentNavigationController: UINavigationController? {
        return selectedViewController as? UINavigationController
    }
    
    private(set) var model: [TabbarItem]!
    private var leadingConstraint: NSLayoutConstraint?
    
    class func instantiate(with models: [TabbarItem] ) -> TabbarViewController {
        let vc = TabbarViewController.controllerFromStoryboard(.tabbar)
        vc.models = models
        return vc
    }
    
    deinit {
        printDeinit()
    }
    
}

// MARK: - View life cycle
extension TabbarViewController {
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        edgesForExtendedLayout = []
        let normal: [NSAttributedString.Key: Any] = [ .foregroundColor: UIColor.darkGray ]
        
        let highlighted: [NSAttributedString.Key: Any] = [ .foregroundColor: UIColor.black ]
        
        UITabBarItem.appearance().setTitleTextAttributes(normal, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(highlighted, for: .selected)
        
        tabBar.unselectedItemTintColor = UIColor.darkGray
        presenter?.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.viewDidAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    
}

// MARK: - Public methods
extension TabbarViewController {
    func setSelect(_ tabbarItem: TabbarItem) {
        guard let idx = models.firstIndex(of: tabbarItem) else {
            return
        }
        selectedIndex = idx
        
        guard let controller = viewControllers?[selectedIndex] as? UINavigationController else {
            assertionFailure()
            return
        }
        
        presenter?.didSelect(models[selectedIndex], navController: controller)
    }
}



// MARK: - Tabbar delegate
extension TabbarViewController {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let controller = viewControllers?[selectedIndex] as? UINavigationController else {
            assertionFailure()
            return
        }
        
        presenter?.didSelect(models[selectedIndex], navController: controller)
    }
}
