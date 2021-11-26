//
//  UIViewController+Extensions.swift
//  IdeaSoft_Project
//
//  Created by IdeaSoft on 26.11.2021.
//

import UIKit

extension UIViewController {
    static func controllerInStoryboard(_ storyboard: UIStoryboard, identifier: String) -> Self {
        return instantiateControllerInStoryboard(storyboard, identifier: identifier)
    }
    
    static func controllerInStoryboard(_ storyboard: UIStoryboard) -> Self {
        return controllerInStoryboard(storyboard, identifier: nameOfClass())
    }
    
    static func controllerFromStoryboard(_ storyboard: Storyboards) -> Self {
        return controllerInStoryboard(UIStoryboard(name: storyboard.rawValue, bundle: nil), identifier: nameOfClass())
    }
    
    static func controllerFromStoryboard(_ storyboard: Storyboards, identifier: String) -> Self {
        return controllerInStoryboard(UIStoryboard(name: storyboard.rawValue, bundle: nil), identifier: identifier)
    }
}

private extension UIViewController {
    static func instantiateControllerInStoryboard<T: UIViewController>(_ storyboard: UIStoryboard, identifier: String) -> T {
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
}


// MARK: - Modal presentation
extension UIViewController {
    open func present(_ viewControllerToPresent: UIViewController, animated flag: Bool) {
        self.present(viewControllerToPresent, animated: flag, completion: nil)
    }

    open func dismiss(animated flag: Bool) {
        self.dismiss(animated: flag, completion: nil)
    }
}

// MARK: - Close
extension UIViewController {
    /// Close the view controller, if view controller is in the navigation controller stack then then it will be poped, otherwise dismissed
    ///
    /// - Parameter flag: animation
    func close(animated flag: Bool) {
        if let navVC = self.navigationController {
            if navVC.viewControllers.first == self {
                dismiss(animated: flag)
            } else {
                navVC.popViewController(animated: flag)
            }

        } else {
            self.dismiss(animated: flag)
        }
    }
}


// MARK: - Present in parent
extension UIViewController {
    @discardableResult
    func add(_ child: UIViewController, into containerView: UIView? = nil) -> (leading: NSLayoutConstraint, trailing: NSLayoutConstraint, top: NSLayoutConstraint, bottom: NSLayoutConstraint) {
        let v = containerView ?? self.view
        guard let holderView = v  else { return (NSLayoutConstraint(), NSLayoutConstraint(), NSLayoutConstraint(), NSLayoutConstraint()) }
        addChild(child)
        child.view.frame = holderView.bounds
        child.willMove(toParent: self)
        holderView.addSubview(child.view)
        child.didMove(toParent: self)
        
        child.view.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = child.view.leadingAnchor.constraint(equalTo: holderView.leadingAnchor)
        leading.isActive = true
        
        let trailing = holderView.trailingAnchor.constraint(equalTo: child.view.trailingAnchor)
        trailing.isActive = true
        
        let top = child.view.topAnchor.constraint(equalTo: holderView.topAnchor)
        top.isActive = true
        
        let bottom = holderView.bottomAnchor.constraint(equalTo: child.view.bottomAnchor)
        bottom.isActive = true
        
        return (leading, trailing, top, bottom)

    }

    func remove() {
        guard parent != nil else { return }

        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
}

extension UIViewController {
    var topPadding: CGFloat {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        return window?.safeAreaInsets.top ?? 20
    }
}


// MARK: - Hide keyboard
extension UIViewController {
    func addKeyboardAvoidingTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleSingleTap(_ gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
