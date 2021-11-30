//
//  ModalSheetAnimator.swift
//  IdeaSoft_Project
//
//  Created by IdeaSoft on 30.11.2021.
//

import UIKit

final class ModalSheetAnimator: NSObject {
    private var isPresenting = false
    private var anim: UIViewImplicitlyAnimating?
    private var context: UIViewControllerContextTransitioning?
    private let dimViewColor: UIColor
    
    fileprivate lazy var dimView: UIView = {
        let view = UIView()
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.backgroundColor = dimViewColor
        return view
    }()
    
    private (set) var onDismiss: ((ModalSheetAnimator) -> Void)?
    fileprivate weak var presentedViewController: UIViewController?
    
    var dismissCompletion: CompletionBlock?
    
    init(dimViewColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3), onDismiss: ((ModalSheetAnimator) -> Void)? = nil) {
        self.dimViewColor = dimViewColor
        self.onDismiss = onDismiss
        super.init()
    }
    
    deinit {
        print("\(self) deinit")
    }
    
    @objc private func dismiss() {
        dismissCompletion?()
        presentedViewController?.dismiss(animated: true,
                                         completion: nil)
    }
    
    private var isInteracting: Bool = false
    
    private func addTapDismissRecognizer(to view: UIView) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
    }
}

extension ModalSheetAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animator = interruptibleAnimator(using: transitionContext)
        animator.startAnimation()
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        if let animator = anim {
            return animator
        }
        
        var animations: (() -> Void) = {}
        
        let containerView = transitionContext.containerView
        let containerBounds = containerView.bounds
        
        if isPresenting {
            guard let toView = transitionContext.view(forKey: .to) else {
                fatalError()
            }
            
            var initialFrame = containerBounds
            initialFrame.origin.y = containerBounds.maxY
            
            containerView.addSubview(dimView)
            dimView.frame = containerBounds
            dimView.alpha = 0.0
            
            containerView.addSubview(toView)
            toView.frame = initialFrame
            
            animations = { [weak self] in
                toView.frame = containerBounds
                self?.dimView.alpha = 0.7
            }
        } else {
            guard let fromView = transitionContext.view(forKey: .from) else {
                fatalError()
            }
            
            var finalFrame = containerBounds
            finalFrame.origin.y = containerBounds.maxY
            
            animations = { [weak self] in
                fromView.frame = finalFrame
                self?.dimView.alpha = 0.0
            }
        }
        
        let animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext),
                                              curve: .easeInOut, animations: nil)
        
        animator.addAnimations(animations)
        
        animator.addCompletion { [weak self] position in
            if position == .end {
                self?.completeTransition(with: transitionContext)
            }
            self?.finalizeTransition(with: transitionContext, cancelled: position != .end)
        }
        
        anim = animator
        return animator
    }
    
    private func finalizeTransition(with context: UIViewControllerContextTransitioning?, cancelled: Bool) {
        if isInteracting {
            if cancelled {
                context?.cancelInteractiveTransition()
            } else {
                context?.finishInteractiveTransition()
            }
        }
        
        context?.completeTransition(!cancelled)
    }
    
    private func completeTransition(with context: UIViewControllerContextTransitioning) {
        if !isPresenting {
            dimView.removeFromSuperview()
        } else {
            let toView = context.view(forKey: .to)
            addTapDismissRecognizer(to: toView!)
            
            presentedViewController = context.viewController(forKey: .to)
        }
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        isInteracting = false
        context = nil
        anim = nil
        
        if transitionCompleted && !isPresenting {
            onDismiss?(self)
        }
    }
}

extension ModalSheetAnimator: UIViewControllerInteractiveTransitioning {
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        _ = interruptibleAnimator(using: transitionContext)
    }
}

extension ModalSheetAnimator: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let view = gestureRecognizer.view else {
            return true
        }
        
        let touchLocation = touch.location(in: view)
        
        switch gestureRecognizer {
        case is UITapGestureRecognizer:
            return view.hitTest(touchLocation, with: nil) === view
        default:
            return true
        }
    }
}

extension ModalSheetAnimator: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
    
    // swiftlint:disable vertical_parameter_alignment
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return isInteracting ? self : nil
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
}

