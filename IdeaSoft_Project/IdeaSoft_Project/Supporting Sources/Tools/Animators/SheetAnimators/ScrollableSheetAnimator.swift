//
//  ModalSheetAnimator.swift
//  IdeaSoft_Project
//
//  Created by IdeaSoft on 30.11.2021.
//

import UIKit

final class ScrollableSheetAnimator: NSObject {
    private var isPresenting = false
    private var anim: UIViewImplicitlyAnimating?
    private var context: UIViewControllerContextTransitioning?
    private var contentView: UIView?
    var panView: UIView? {
        didSet {
            if let view = panView {
                addPanDismissRecognizer(to: view)
            }
        }
    }
    
    private var dimViewColor: UIColor
    
    fileprivate lazy var dimView: UIView = {
        let view = UIView()
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.backgroundColor = dimViewColor
        return view
    }()
    
    private (set) var onDismiss: ((ScrollableSheetAnimator) -> Void)?
    fileprivate weak var presentedViewController: UIViewController?
    
    init(dimViewColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3), onDismiss: ((ScrollableSheetAnimator) -> Void)? = nil) {
        self.onDismiss = onDismiss
        self.dimViewColor = dimViewColor
        super.init()
        
    }
    
    deinit {
        print("\(self) deinit")
    }
    
    @objc private func dismiss() {
        presentedViewController?.dismiss(animated: true,
                                         completion: nil)
    }
    
    private var isInteracting: Bool = false
    
    private func addTapDismissRecognizer(to view: UIView) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func addPanDismissRecognizer(to view: UIView) {
        let recognizer = DirectionalPanGestureRecognizer(direction: .vertical,
                                                         target: self, action: #selector(handlePan(_:)))
        recognizer.delegate = self
        view.addGestureRecognizer(recognizer)
    }
}

extension ScrollableSheetAnimator: UIViewControllerAnimatedTransitioning {
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
            let viewToaddPan = panView ?? toView
            addPanDismissRecognizer(to: viewToaddPan!)
            
            presentedViewController = context.viewController(forKey: .to)
        }
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        isInteracting = false
        context = nil
        anim = nil
        contentView = nil
        
        if transitionCompleted && !isPresenting {
            onDismiss?(self)
        }
    }
}

extension ScrollableSheetAnimator: UIViewControllerInteractiveTransitioning {
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        _ = interruptibleAnimator(using: transitionContext)
    }
}

extension ScrollableSheetAnimator: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let view = gestureRecognizer.view else {
            return true
        }
        
        let touchLocation = touch.location(in: view)
        
        switch gestureRecognizer {
        case is UITapGestureRecognizer:
            return view.hitTest(touchLocation, with: nil) === view
        case is DirectionalPanGestureRecognizer:
            return view.hitTest(touchLocation, with: nil) !== view
        default:
            return true
        }
    }
}

extension ScrollableSheetAnimator: UIViewControllerTransitioningDelegate {
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

private extension ScrollableSheetAnimator {
    private func contentView(for rec: UIGestureRecognizer, currentView: UIView) -> UIView? {
        guard let superview = currentView.superview, superview !== rec.view else {
            return currentView
        }
        return contentView(for: rec, currentView: superview)
    }
    
    @objc private func handlePan(_ rec: UIPanGestureRecognizer) {
        switch rec.state {
        case .began:
            handlePanBeginning(for: rec)
        case .changed:
            handlePanChange(for: rec)
        case .ended, .cancelled:
            handlePanEnd(for: rec)
        default:
            break
        }
    }
    
    private func handlePanBeginning(for rec: UIPanGestureRecognizer) {
        let view = rec.view!
        let location = rec.location(in: view)
        
        guard let touchedView = view.hitTest(location, with: nil),
            let contentView = self.contentView(for: rec, currentView: touchedView) else {
                return
        }
        self.contentView = contentView
        isInteracting = true
        dismiss()
    }
    
    private func handlePanChange(for rec: UIPanGestureRecognizer) {
        let view = rec.view!
        let delta = rec.translation(in: rec.view)
        
        var percentComplete: CGFloat = delta.y / view.frame.height
        if let animator = anim {
            percentComplete += animator.fractionComplete
        }
        
        anim?.fractionComplete = percentComplete
        context?.updateInteractiveTransition(percentComplete)
        rec.setTranslation(.zero, in: view)
    }
    
    private func handlePanEnd(for rec: UIPanGestureRecognizer) {
        let view = rec.view!
        let delta = rec.translation(in: rec.view)
        
        var percentComplete: CGFloat = delta.y / view.frame.height
        
        if let animator = anim {
            percentComplete += animator.fractionComplete
        }
        let velocity = rec.velocity(in: view)
        
        anim?.pauseAnimation()
        
        let pct = percentComplete / (contentView!.frame.height / view.frame.height)
        
        var cancelTransition: Bool = false
        if velocity.y > 1000 {
            cancelTransition = false
        } else if pct < 0.2 || velocity.y < -100 {
            cancelTransition = true
        } else {
            cancelTransition = false
        }
        
        let durationFactor = cancelTransition ? percentComplete : (1.0 - percentComplete)
        anim?.isReversed = cancelTransition
        
        let timingParameters = UICubicTimingParameters(animationCurve: .easeInOut)
        anim?.continueAnimation?(withTimingParameters: timingParameters, durationFactor: durationFactor)
    }
}
