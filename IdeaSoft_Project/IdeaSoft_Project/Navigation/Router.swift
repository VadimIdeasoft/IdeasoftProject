//
//  Router.swift
//  IdeaSoft_Project
//
//  Created by IdeaSoft on 26.11.2021.
//

import UIKit

typealias RouterCompletions = [UIViewController : CompletionBlock]

final class Router: NSObject, RouterType, UINavigationControllerDelegate {
    
    // MARK:- Private variables
    public var rootViewController: UIViewController? {
        return navigationController.viewControllers.first
    }
    
    public var hasRootController: Bool {
        return rootViewController != nil
    }
    
    public let navigationController: UINavigationController
    
    private var completions: RouterCompletions
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        completions = [:]
        
        super.init()
        
        self.navigationController.delegate = self
    }
    
    var navigationContainer: UIViewController? = nil
    
    var toPresent: UIViewController? {
        return navigationContainer ?? navigationController
    }
}

// MARK:- Private methods
private extension Router {
    func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
}

// MARK:- RouterType
extension Router {
    var viewControllers: [UIViewController]? {
        return (toPresent as? UINavigationController)?.viewControllers
    }
    
    func report(about error: Error, title: String?) {
        let vc = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Dismiss", comment: ""), style: .cancel, handler: nil)
        vc.addAction(cancelAction)
        present(vc, animated: true)
    }
    
    // MARK: Present
    func present(_ module: Presentable?) {
        present(module, animated: true)
    }
    
    func present(_ module: Presentable?, animated: Bool) {
        guard let controller = module?.toPresent else { return }
        navigationController.present(controller, animated: animated, completion: nil)
    }
    
    // MARK: Push
    func push(_ module: Presentable?)  {
        push(module, animated: true)
    }
    
    func push(_ module: Presentable?, animated: Bool)  {
        push(module, animated: animated, completion: nil)
    }
    
    func push(_ module: Presentable?, animated: Bool, completion: CompletionBlock?) {
        guard
            let controller = module?.toPresent,
            !(controller is UINavigationController)
        else { assertionFailure("⚠️Deprecated push UINavigationController."); return }
        
        if let completion = completion {
            completions[controller] = completion
        }
        navigationController.pushViewController(controller, animated: animated)
    }
    
    // MARK: Pop
    func popModule()  {
        popModule(animated: true)
    }
    
    func popModule(animated: Bool)  {
        if let controller = navigationController.popViewController(animated: animated) {
            runCompletion(for: controller)
        }
    }
    
    func popTo(viewController: UIViewController, animated: Bool) {
        if let controllers = navigationController.popToViewController(viewController, animated: animated) {
            controllers.forEach(runCompletion(for:))
        }
    }
    
    // MARK: Dismiss
    func dismissModule() {
        dismissModule(animated: true, completion: nil)
    }
    
    func dismissModule(animated: Bool, completion: CompletionBlock?) {
        navigationController.dismiss(animated: animated, completion: completion)
    }
    
    // MARK: Set Root
    func setRootModule(_ module: Presentable?) {
        setRootModule(module, hideBar: false, animated: false)
    }
    
    func setRootModule(_ module: Presentable?, hideBar: Bool) {
        setRootModule(module, hideBar: hideBar, animated: false)
    }
    
    func setRootModule(_ module: Presentable?, hideBar: Bool, animated: Bool) {
        guard let controller = module?.toPresent else { return }
        navigationController.setViewControllers([controller], animated: animated)
        navigationController.isNavigationBarHidden = hideBar
    }
    
    // MARK: Pop to Root
    func popToRootModule(animated: Bool) {
        if let controllers = navigationController.popToRootViewController(animated: animated) {
            controllers.forEach { controller in
                runCompletion(for: controller)
            }
        }
    }
    
    func setBar(hidden: Bool, animated: Bool) {
        navigationController.setNavigationBarHidden(hidden, animated: animated)
    }
    
    func add(_ module: Presentable?) {
        guard let controller = module?.toPresent else { return }
        rootViewController?.add(controller)
    }
    
    func remove(_ module: Presentable?) {
        guard let controller = module?.toPresent else { return }
        controller.remove()
    }
    
    func showModal(_ module: Presentable?) {
        guard let vc = module?.toPresent else { return }
        rootViewController?.showModal(vc)
    }
}

// MARK: UINavigationControllerDelegate
extension Router {
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        // Ensure the view controller is popping
        guard let poppedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
              !navigationController.viewControllers.contains(poppedViewController) else {
                  return
              }
        
        runCompletion(for: poppedViewController)
    }
}

private var key = (router: "UINavigationController_Router", empty: "RouterID_of_UINavigationController_Property")


final class ModalSegue: UIStoryboardSegue {
    private var presentation: ModalPresentationController!
    private var selfRetainer: ModalSegue?
    
    override func perform() {
        destination.modalPresentationStyle = .custom
        destination.transitioningDelegate = self
        source.present(destination, animated: true, completion: nil)
    }
    
    deinit {
        printDeinit()
    }
}

extension ModalSegue: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        selfRetainer = self
        presentation = ModalPresentationController(presentedViewController: presented, presenting: presenting)
        presentation.onCompletion = { [weak self] in
            self?.selfRetainer = nil
        }
        return presentation
    }
}

extension UIViewController {
    func showModal(_ vc: UIViewController) {
        let segue = ModalSegue(identifier: nil, source: self, destination: vc)
        segue.perform()
        
    }
}
