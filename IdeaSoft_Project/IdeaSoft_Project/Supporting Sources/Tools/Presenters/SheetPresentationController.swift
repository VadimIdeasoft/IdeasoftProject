//
//  SheetPresentationController.swift
//  IdeaSoft_Project
//
//  Created by IdeaSoft on 26.11.2021.
//

import UIKit

final class SheetPresentationController: UIPresentationController {
    //    private let CORNER_RADIUS: CGFloat = 10
    var dimmingView: UIView!
    var presentationWrappingView: UIView!
    override var presentedView: UIView {
        return presentationWrappingView
    }
    
    deinit {
        printDeinit()
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentedViewController)
        
        
        // The presented view controller must have a modalPresentationStyle
        // of UIModalPresentationCustom for a custom presentation controller
        // to be used.
        presentedViewController.transitioningDelegate = self
        presentedViewController.modalPresentationStyle = .custom
    }
    
    ///
    ///  This is one of the first methods invoked on the presentation controller
    ///  at the start of a presentation.  By the time this method is called,
    ///  the containerView has been created and the view hierarchy set up for the
    ///  presentation.  However, the -presentedView has not yet been retrieved.
    ///
    override func presentationTransitionWillBegin() {
        // The default implementation of -presentedView returns
        // self.presentedViewController.view.
        let presentedViewControllerView = super.presentedView ?? UIView()
        
        // Wrap the presented view controller's view in an intermediate hierarchy
        // that applies a shadow and rounded corners to the top-left and top-right
        // edges.  The final effect is built using three intermediate views.
        //
        // presentationWrapperView              <- shadow
        //   |- presentationRoundedCornerView   <- rounded corners (masksToBounds)
        //        |- presentedViewControllerWrapperView
        //             |- presentedViewControllerView (presentedViewController.view)
        //
        // SEE ALSO: The note in AAPLCustomPresentationSecondViewController.m.
        
        
        self.presentationWrappingView = {
            
            let presentationWrapperView = UIView(frame: self.frameOfPresentedViewInContainerView)
            //            presentationWrapperView.layer.shadowOpacity = 0.44
            //            presentationWrapperView.layer.shadowRadius = 13.0
            //            presentationWrapperView.layer.shadowOffset = CGSize(width: 0, height: -6.0)
            
            
            //            // presentationRoundedCornerView is CORNER_RADIUS points taller than the
            //            // height of the presented view controller's view.  This is because
            //            // the cornerRadius is applied to all corners of the view.  Since the
            //            // effect calls for only the top two corners to be rounded we size
            //            // the view such that the bottom CORNER_RADIUS points lie below
            //            // the bottom edge of the screen.
            //
            let presentationRoundedCornerView: UIView = {
                let inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                let presentationRoundedCornerView = UIView(frame: presentationWrapperView.bounds.inset(by: inset))
                presentationRoundedCornerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                let corners: UIRectCorner = [.topLeft, .topRight]
                let path = UIBezierPath(roundedRect: presentationRoundedCornerView.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: 10, height: 10))
                let mask = CAShapeLayer()
                
                mask.path = path.cgPath
                presentationRoundedCornerView.layer.mask = mask
                
                return presentationRoundedCornerView
            }()
            
            
            // To undo the extra height added to presentationRoundedCornerView,
            // presentedViewControllerWrapperView is inset by CORNER_RADIUS points.
            // This also matches the size of presentedViewControllerWrapperView's
            // bounds to the size of -frameOfPresentedViewInContainerView.
            
            let presentedViewControllerWrapperView: UIView = {
                let inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                let presentedViewControllerWrapperView = UIView(frame: presentationWrapperView.bounds.inset(by: inset))
                presentedViewControllerWrapperView.autoresizingMask = [.flexibleWidth]
                return presentedViewControllerWrapperView
            }()
            
            // Add presentedViewControllerView -> presentedViewControllerWrapperView.
            presentedViewControllerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            presentedViewControllerView.frame = presentedViewControllerWrapperView.bounds
            presentedViewControllerWrapperView.addSubview(presentedViewControllerView)
            
            // Add presentedViewControllerWrapperView -> presentationRoundedCornerView.
            presentationRoundedCornerView.addSubview(presentedViewControllerWrapperView)
            
            // Add presentationRoundedCornerView -> presentationWrapperView.
            presentationWrapperView.addSubview(presentationRoundedCornerView)
            
            return presentationWrapperView
            
        }()
        
        
        dimmingView = {
            let dimmingView = UIView(frame: self.containerView?.bounds ?? UIScreen.main.bounds)
            
            dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            dimmingView.isOpaque = false
            dimmingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture(recognizer:)))
            dimmingView.addGestureRecognizer(recognizer)
            self.containerView?.addSubview(dimmingView)
            
            return dimmingView
            
        }()
        
        // Get the transition coordinator for the presentation so we can
        //                // fade in the dimmingView alongside the presentation animation.
        //                id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
        let transitionCoordinator = presentedViewController.transitionCoordinator
        dimmingView.alpha = 0
        transitionCoordinator?.animate(alongsideTransition: {
            _ in
            self.dimmingView.alpha = 1
        }, completion: nil)
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        // The value of the 'completed' argument is the same value passed to the
        // -completeTransition: method by the animator.  It may
        // be NO in the case of a cancelled interactive transition.
        if completed == false {
            // The system removes the presented view controller's view from its
            // superview and disposes of the containerView.  This implicitly
            // removes the views created in -presentationTransitionWillBegin: from
            // the view hierarchy.  However, we still need to relinquish our strong
            // references to those view.
            presentationWrappingView = nil
            dimmingView = nil
        }
    }
    
    override func dismissalTransitionWillBegin() {
        // Get the transition coordinator for the dismissal so we can
        // fade out the dimmingView alongside the dismissal animation.
        let transitionCoordinator = presentingViewController.transitionCoordinator;
        transitionCoordinator?.animate(alongsideTransition: { (_) in
            self.dimmingView.alpha = 0
        }, completion: nil)
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        // The value of the 'completed' argument is the same value passed to the
        // -completeTransition: method by the animator.  It may
        // be NO in the case of a cancelled interactive transition.
        if completed == false {
            // The system removes the presented view controller's view from its
            // superview and disposes of the containerView.  This implicitly
            // removes the views created in -presentationTransitionWillBegin: from
            // the view hierarchy.  However, we still need to relinquish our strong
            // references to those view.
            presentationWrappingView = nil
            dimmingView = nil
        }
    }
    
    
    ///
    ///  This method is invoked whenever the presentedViewController's
    ///  preferredContentSize property changes.  It is also invoked just before the
    ///  presentation transition begins (prior to -presentationTransitionWillBegin).
    ///
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        //        if container == self.presentedViewController {
        //            containerView?.setNeedsLayout()
        //        }
        
        if presentedViewController == container as? UIViewController {
            containerView?.setNeedsLayout()
        } else {
            assertionFailure()
        }
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        if let vc = container as? UIViewController, vc == presentedViewController  {
            return vc.preferredContentSize
        } else {
            return super.size(forChildContentContainer: container, withParentContainerSize: parentSize)
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        
        
        // The presented view extends presentedViewContentSize.height points from
        // the bottom edge of the screen.
        
        var topinset: CGFloat = 30
        var bottominset: CGFloat = 0
        let window = UIApplication.window
        
        topinset = max(topinset, window?.safeAreaInsets.top ?? topinset)
        bottominset = window?.safeAreaInsets.bottom ?? bottominset
        
        //        print("👍 ", String(describing: type(of: self)),":", #function, "    topinset ", topinset)
        //        print("👍 ", String(describing: type(of: self)),":", #function, " bottominset ", bottominset)
        
        
        var containerViewBounds = self.containerView?.bounds ?? super.frameOfPresentedViewInContainerView
        containerViewBounds.size.height = containerViewBounds.height - (topinset + bottominset)
        let presentedViewContentSize = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerViewBounds.size)
        
        //        let contentSize = UIScreen.main.bounds.size
        
        
        
        var frame = CGRect(origin: .zero, size: presentedViewContentSize)
        frame.origin.y = UIScreen.main.bounds.height - presentedViewContentSize.height
        frame.origin.x = (UIScreen.main.bounds.width - presentedViewContentSize.width) / 2
        
        return frame
        
        //        var presentedViewConXtrollerFrame = containerViewBounds
        //
        //        if presentedViewContentSize.height >= UIScreen.main.bounds.height - topinset - bottominset {
        //            presentedViewControllerFrame.size.width = containerViewBounds.width - 40
        //            presentedViewControllerFrame.size.height = presentedViewContentSize.height - bottominset - topinset
        //            presentedViewControllerFrame.origin.x = 20
        //
        //            presentedViewControllerFrame.origin.y = topinset - (containerViewBounds.height - presentedViewContentSize.height) / 2
        //        } else {
        //
        //            presentedViewControllerFrame.size.width = containerViewBounds.width - 40
        //            presentedViewControllerFrame.size.height = presentedViewContentSize.height
        //            presentedViewControllerFrame.origin.x = 20
        //            presentedViewControllerFrame.origin.y = max(20, (containerViewBounds.height - presentedViewContentSize.height) / 2)
        //        }
        //
        //
        //
        //
        //        return presentedViewControllerFrame
    }
    
    ///
    ///  This method is similar to the -viewWillLayoutSubviews method in
    ///  UIViewController.  It allows the presentation controller to alter the
    ///  layout of any custom views it manages.
    ///
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        self.dimmingView.frame = self.containerView?.bounds ?? UIScreen.main.bounds
        self.presentationWrappingView.frame = self.frameOfPresentedViewInContainerView
    }
    
    
    
    @objc private func handleTapGesture(recognizer: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}


extension SheetPresentationController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return (transitionContext?.isAnimated ?? false) ? 0.25 : 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //        UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        //        UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        let fromViewController = transitionContext.viewController(forKey: .from)!
        let toViewController = transitionContext.viewController(forKey: .to)!
        
        let containerView = transitionContext.containerView
        
        // For a Presentation:
        //      fromView = The presenting view.
        //      toView   = The presented view.
        // For a Dismissal:
        //      fromView = The presented view.
        //      toView   = The presenting view.
        let toView = transitionContext.view(forKey: .to)!
        // If NO is returned from -shouldRemovePresentersView, the view associated
        // with UITransitionContextFromViewKey is nil during presentation.  This
        // intended to be a hint that your animator should NOT be manipulating the
        // presenting view controller's view.  For a dismissal, the -presentedView
        // is returned.
        //
        // Why not allow the animator manipulate the presenting view controller's
        // view at all times?  First of all, if the presenting view controller's
        // view is going to stay visible after the animation finishes during the
        // whole presentation life cycle there is no need to animate it at all — it
        // just stays where it is.  Second, if the ownership for that view
        // controller is transferred to the presentation controller, the
        // presentation controller will most likely not know how to layout that
        // view controller's view when needed, for example when the orientation
        // changes, but the original owner of the presenting view controller does.
        
        let fromView = transitionContext.view(forKey: .from) ?? fromViewController.view!
        
        let isPresenting = fromViewController == self.presentingViewController
        
        // This will be the current frame of fromViewController.view.
        //        CGRect __unused fromViewInitialFrame = [transitionContext initialFrameForViewController:fromViewController];
        
        _ = transitionContext.initialFrame(for: fromViewController)
        
        
        // For a presentation which removes the presenter's view, this will be
        // CGRectZero.  Otherwise, the current frame of fromViewController.view.
        //        CGRect fromViewFinalFrame = [transitionContext finalFrameForViewController:fromViewController];
        var fromViewFinalFrame = transitionContext.finalFrame(for: fromViewController)
        
        
        // This will be CGRectZero.
        //        CGRect toViewInitialFrame = [transitionContext initialFrameForViewController:toViewController];
        var toViewInitialFrame = transitionContext.initialFrame(for: toViewController)
        
        // For a presentation, this will be the value returned from the
        // presentation controller's -frameOfPresentedViewInContainerView method.
        //        CGRect toViewFinalFrame = [transitionContext finalFrameForViewController:toViewController];
        let toViewFinalFrame = transitionContext.finalFrame(for: toViewController)
        
        // We are responsible for adding the incoming view to the containerView
        // for the presentation (will have no effect on dismissal because the
        // presenting view controller's view was not removed).
        //        [containerView addSubview:toView];
        containerView.addSubview(toView)
        
        if (isPresenting) {
            toViewInitialFrame.origin.y = UIScreen.main.bounds.height
            toViewInitialFrame.origin.x = (UIScreen.main.bounds.width - toViewFinalFrame.width) / 2
            toViewInitialFrame.size = toViewFinalFrame.size
            toView.frame = toViewInitialFrame
        } else {
            // Because our presentation wraps the presented view controller's view
            // in an intermediate view hierarchy, it is more accurate to rely
            // on the current frame of fromView than fromViewInitialFrame as the
            // initial frame (though in this example they will be the same).
            //            fromViewFinalFrame = CGRectOffset(fromView.frame, 0, CGRectGetHeight(fromView.frame));
            
            fromViewFinalFrame = fromView.frame.offsetBy(dx: 0, dy: fromView.frame.height)
        }
        
        //        let transitionDuration = [self transitionDuration:transitionContext];
        let transitionDuration = self.transitionDuration(using: transitionContext)
        
        //        [UIView animateWithDuration:transitionDuration animations:^{
        //            if (isPresenting)
        //            toView.frame = toViewFinalFrame;
        //            else
        //            fromView.frame = fromViewFinalFrame;
        //
        //            } completion:^(BOOL finished) {
        //            // When we complete, tell the transition context
        //            // passing along the BOOL that indicates whether the transition
        //            // finished or not.
        //            BOOL wasCancelled = [transitionContext transitionWasCancelled];
        //            [transitionContext completeTransition:!wasCancelled];
        //            }];
        
        UIView.animate(withDuration: transitionDuration, animations: {
            if isPresenting {
                toView.frame = toViewFinalFrame
            } else {
                fromView.frame = fromViewFinalFrame
            }
        }) { (finished: Bool) in
            let wasCanceled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCanceled)
        }
    }
}


extension SheetPresentationController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        assert(self.presentedViewController == presented, "You didn't initialize \(self) with the correct presentedViewController.  Expected \(presented), got \(self.presentedViewController).");
        
        return self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

