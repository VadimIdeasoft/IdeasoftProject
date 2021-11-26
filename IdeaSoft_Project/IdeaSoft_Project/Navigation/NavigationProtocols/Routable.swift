//
//  RouterType.swift
//  IdeaSoft_Project
//
//  Created by IdeaSoft on 26.11.2021.
//

import UIKit

protocol RouterType: Presentable {
    
    /// Stack of view controlls
    var navigationController: UINavigationController { get }
    var viewControllers: [UIViewController]? { get }
    
    func present(_ module: Presentable?)
    func present(_ module: Presentable?, animated: Bool)
    
    func push(_ module: Presentable?)
    func push(_ module: Presentable?, animated: Bool)
    func push(_ module: Presentable?, animated: Bool, completion: CompletionBlock?)
    
    func popModule()
    func popModule(animated: Bool)
    func popTo(viewController: UIViewController, animated: Bool)
    
    func dismissModule()
    func dismissModule(animated: Bool, completion: CompletionBlock?)
    
    func setRootModule(_ module: Presentable?)
    func setRootModule(_ module: Presentable?, hideBar: Bool)
    func setRootModule(_ module: Presentable?, hideBar: Bool, animated: Bool)
    
    func popToRootModule(animated: Bool)
    func report(about error: Error, title: String?)
    
    func setBar(hidden: Bool, animated: Bool)
    
    func add(_ module: Presentable?)
    func remove(_ module: Presentable?)
    
    func showModal(_ module: Presentable?)
    
}
