//
//  FadeAnimationController.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import struct   TapAdditionsKitV2.TypeAlias
import enum     TapVisualEffectViewV2.TapBlurEffectStyle
import class    TapVisualEffectViewV2.TapVisualEffectView
import class    UIKit.UIView.UIView
import struct   UIKit.UIView.UIViewAnimationOptions
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerAnimatedTransitioning
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerContextTransitioning

internal final class FadeAnimationController: NSObject {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal let operation: ViewControllerOperation
    
    // MARK: Methods
    
    internal init(operation: ViewControllerOperation) {
        
        self.operation = operation
        
        super.init()
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let animationDuration: TimeInterval = 0.4
        
        //@available(*, unavailable) private init() { }
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
extension FadeAnimationController: UIViewControllerAnimatedTransitioning {
    
    internal func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return transitionContext?.isAnimated ?? true ? Constants.animationDuration : 0.0
    }
    
    internal func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard
            
            let fromController = transitionContext.viewController(forKey: .from),
            let toController = transitionContext.viewController(forKey: .to),
            let fromView = fromController.view,
            let toView = toController.view
            
        else { return }
        
        let containerView = transitionContext.containerView
        var viewToFade: UIView
        var initialAlpha: CGFloat
        var finalAlpha: CGFloat
        var animationOptions: UIView.AnimationOptions
        
        switch self.operation {
            
        case .presentation:
            
            containerView.addSubview(fromView)
            containerView.addSubview(toView)
            
            viewToFade          = toView
            initialAlpha        = 0.0
            finalAlpha          = 1.0
            animationOptions    = [.beginFromCurrentState, .curveEaseOut]
            
        case .dismissal:
            
            containerView.addSubview(toView)
            containerView.addSubview(fromView)
            
            viewToFade          = fromView
            initialAlpha        = 1.0
            finalAlpha          = 0.0
            animationOptions    = [.beginFromCurrentState, .curveEaseIn]
        }
        
        var blurView:           TapVisualEffectView?
        var initialBlurStyle:   TapBlurEffectStyle
        var finalBlurStyle:     TapBlurEffectStyle
        
        switch self.operation {
            
        case .presentation:
            
            blurView            = toView.tap_subview(ofClass: TapVisualEffectView.self)
            initialBlurStyle    = .none
            finalBlurStyle      = blurView?.style ?? .none
            
        case .dismissal:
            
            blurView            = fromView.tap_subview(ofClass: TapVisualEffectView.self)
            initialBlurStyle    = blurView?.style ?? .none
            finalBlurStyle      = .none
        }
        
        blurView?.style = initialBlurStyle
        viewToFade.alpha = initialAlpha
        
        fromView.frame = transitionContext.finalFrame(for: fromController)
        toView.frame = transitionContext.finalFrame(for: toController)
        
        let animations: TypeAlias.ArgumentlessClosure = {
            
            blurView?.style = finalBlurStyle
            viewToFade.alpha = finalAlpha
        }
        
        let animationDuration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: animations) { (finished) in
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
