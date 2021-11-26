//
//  TabbarModule.swift
//  IdeaSoft_Project
//
//  Created by IdeaSoft on 26.11.2021.
//

import UIKit

protocol TabbarModule: BaseViewProtocol {
    var onCompletion: CompletionBlock? { get set }
    var onError: ((Error, String?) -> Void)? { get set }
    
    var onViewDidLoad: CompletionBlock? { get set }
    var onViewDidAppear: CompletionBlock? { get set }
    var onDidSelectTabbarItem: ((TabbarItem, UINavigationController) -> Void)? { get set }
    
    var tabbarItemModels: [TabbarItem] { get }
    var onDeinit: CompletionBlock? { get set }
    
    func setSelect(_ tabbarItem: TabbarItem)
    func currentNavitationController() -> UINavigationController?
    func setViewControllers(_ viewControllers: [UIViewController], animated: Bool)
}
