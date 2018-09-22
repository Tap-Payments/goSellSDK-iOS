//
//  PopupPresentationAnimationController.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct   CoreGraphics.CGBase.CGFloat
import struct   CoreGraphics.CGGeometry.CGRect
import struct   TapAdditionsKit.TypeAlias
import class    TapVisualEffectView.TapVisualEffectView
import class    UIKit.UIColor.CGColor
import class    UIKit.UIColor.UIColor
import class    UIKit.UIResponder.UIResponder
import class    UIKit.UIView.UIView
import struct   UIKit.UIView.UIViewKeyframeAnimationOptions
import class    UIKit.UIViewController.UIViewController
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerAnimatedTransitioning
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerContextTransitioning

internal class PopupPresentationAnimationController: NSObject {
    
    // MARK: - Internal -
    
    internal typealias PopupPresentationViewController = UIViewController & PopupPresentationSupport
    
    // MARK: Properties
    
    internal unowned let fromViewController: UIViewController
    internal unowned let toViewController: UIViewController
    
    internal var canFinishInteractiveTransitionDecisionHandler: ((@escaping TypeAlias.BooleanClosure) -> Void)?
    
    // MARK: Methods
    
    internal convenience init(presentationFrom from: UIViewController, to: PopupPresentationViewController, overlaysFromView: Bool = true, overlaySupport: PopupOverlaySupport? = nil) {
        
        self.init(operation: .presentation, from: from, to: to, overlaysBottomView: overlaysFromView, overlaySupport: overlaySupport)
    }
    
    internal convenience init(dismissalFrom from: PopupPresentationViewController, to: UIViewController, overlaysToView: Bool = true, overlaySupport: PopupOverlaySupport? = nil) {
        
        self.init(operation: .dismissal, from: from, to: to, overlaysBottomView: overlaysToView, overlaySupport: overlaySupport)
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let animationDuration: TimeInterval = 0.4
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
    
    private let operation: ViewControllerOperation
    private let overlaysBottomView: Bool
    private weak var overlaySupport: PopupOverlaySupport?
    
    private weak var firstResponderOnMomentOfDismissal: UIResponder?
    
    // MARK: Methods
    
    private init(operation: ViewControllerOperation, from: UIViewController, to: UIViewController, overlaysBottomView: Bool, overlaySupport: PopupOverlaySupport?) {
        
        self.operation          = operation
        self.fromViewController = from
        self.toViewController   = to
        self.overlaysBottomView = overlaysBottomView
        self.overlaySupport     = overlaySupport
        
        super.init()
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
extension PopupPresentationAnimationController: UIViewControllerAnimatedTransitioning {
    
    internal func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return transitionContext?.isAnimated ?? true ? Constants.animationDuration : 0.0
    }
    
    internal func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard
            
            let fromController: UIViewController = transitionContext.viewController(forKey: .from),
            let toController: UIViewController = transitionContext.viewController(forKey: .to),
            let fromView: UIView = fromController.view,
            let toView: UIView = toController.view
            
        else { return }
        
        var presentationSupport: (UIViewController & PopupPresentationSupport)?
        let containerView: UIView = transitionContext.containerView
        
        switch self.operation {
            
        case .presentation:
            
            containerView.addSubview(fromView)
            containerView.addSubview(toView)
            
            presentationSupport = toController as? UIViewController & PopupPresentationSupport
            
        case .dismissal:
            
            containerView.addSubview(toView)
            containerView.addSubview(fromView)
            
            presentationSupport = fromController as? UIViewController & PopupPresentationSupport
        }
        
        guard let nonnullPresentationSupport: UIViewController & PopupPresentationSupport = presentationSupport else { return }
        
        let layoutView: UIView = nonnullPresentationSupport.viewToLayout
        let finalFrame: CGRect = transitionContext.finalFrame(for: nonnullPresentationSupport)
        layoutView.frame = finalFrame
        
        var initialConstant: CGFloat
        var finalConstant: CGFloat
        var initialAlpha: CGFloat
        var bottomViewInitialTopOffset: CGFloat
        var bottomViewFinalTopOffset: CGFloat
        
        if self.operation == .presentation {
            
            initialConstant = finalFrame.height
            finalConstant = 0.0
            initialAlpha = 0.0
            bottomViewInitialTopOffset = 0.0
            bottomViewFinalTopOffset = -finalFrame.height
        }
        else {
            
            initialConstant = 0.0
            finalConstant = finalFrame.height
            initialAlpha = 1.0
            bottomViewInitialTopOffset = -finalFrame.height
            bottomViewFinalTopOffset = 0.0
        }
        
        layoutView.alpha = initialAlpha
        
        nonnullPresentationSupport.presentationAnimationAnimatingConstraint?.constant = initialConstant
        layoutView.layout()
        
        
        if !self.overlaysBottomView {
            
            self.overlaySupport?.topOffsetOverlayConstraint?.constant = bottomViewInitialTopOffset
            self.overlaySupport?.layoutView.layout()
        }
        
        let backgroundColor: CGColor? = layoutView.layer.backgroundColor
        if self.operation == .presentation {
            
            layoutView.layer.backgroundColor = UIColor.clear.cgColor
        }
        
        let blurView: TapVisualEffectView? = layoutView.subview(ofClass: TapVisualEffectView.self)
        blurView?.style = self.operation == .presentation ? .none : .light
        
        let animations: TypeAlias.ArgumentlessClosure = {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0) {
                
                if self.operation == .presentation {
                    
                    layoutView.layer.backgroundColor = backgroundColor
                    layoutView.alpha = 1.0
                    blurView?.style = .light
                }
                else {
                    
                    layoutView.layer.backgroundColor = UIColor.clear.cgColor
                    layoutView.alpha = 1.0
                    blurView?.style = .none
                }
                
                nonnullPresentationSupport.presentationAnimationAnimatingConstraint?.constant = finalConstant
                layoutView.layout()
                
                if !self.overlaysBottomView {
                    
                    self.overlaySupport?.topOffsetOverlayConstraint?.constant = bottomViewFinalTopOffset
                    self.overlaySupport?.additionalAnimations(for: self.operation)()
                    self.overlaySupport?.layoutView.layout()
                }
            }
        }
        
        let animationDuration: TimeInterval = self.transitionDuration(using: transitionContext)
        let animationOption: UIView.KeyframeAnimationOptions = UIView.KeyframeAnimationOptions(self.operation == .presentation ? .curveEaseOut : .curveLinear)
        let animationOptions: UIView.KeyframeAnimationOptions = [.beginFromCurrentState, animationOption]
        
        UIView.animateKeyframes(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: animations) { (finished) in
            
            let success: Bool = finished && !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(success)
        }
    }
}

// MARK: - InteractiveTransitionControllerDelegate
extension PopupPresentationAnimationController: InteractiveTransitionControllerDelegate {
    
    internal func interactiveTransitionWillCancel() {
        
        guard let presentationSupport = self.fromViewController as? PopupPresentationSupport else { return }
        
        self.firstResponderOnMomentOfDismissal = presentationSupport.viewToLayout.firstResponder
    }
    
    internal func interactiveTransitionDidCancel() {
        
        guard self.operation == .dismissal, let presentationSupport = self.fromViewController as? PopupPresentationSupport  else { return }
        
        let animations: TypeAlias.ArgumentlessClosure = {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0) {
             
                presentationSupport.presentationAnimationAnimatingConstraint?.constant = 0.0
                self.firstResponderOnMomentOfDismissal?.becomeFirstResponder()
            }
        }
        
        let animationDuration = self.transitionDuration(using: nil)
        let animationOption = UIView.KeyframeAnimationOptions(self.operation == .presentation ? .curveEaseOut : .curveEaseIn)
        let animationOptions: UIView.KeyframeAnimationOptions = [.beginFromCurrentState, animationOption]
        
        UIView.animateKeyframes(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: animations, completion: nil)
    }
    
    internal func canFinishInteractiveTransition(_ decision: @escaping TypeAlias.BooleanClosure) {
        
        if let nonnullHandler = self.canFinishInteractiveTransitionDecisionHandler {
            
            nonnullHandler(decision)
        }
        else {
            
            decision(true)
        }
    }
}
