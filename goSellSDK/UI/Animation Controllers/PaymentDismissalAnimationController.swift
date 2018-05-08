//
//  PaymentDismissalAnimationController.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct TapAdditionsKit.TypeAlias
import class TapVisualEffectView.TapVisualEffectView
import class UIKit.UIView.UIView
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerAnimatedTransitioning
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerContextTransitioning

internal class PaymentDismissalAnimationController: NSObject {
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let animationDuration: TimeInterval = 2.0
        
        @available(*, unavailable) private init() {}
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
extension PaymentDismissalAnimationController: UIViewControllerAnimatedTransitioning {
    
    internal func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return Constants.animationDuration
    }
    
    internal func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard
            
            let fromController = transitionContext.viewController(forKey: .from),
            let toController = transitionContext.viewController(forKey: .to),
            let fromView = fromController.view,
            let toView = toController.view
            
        else { return }
        
        let containerView = transitionContext.containerView
        
        containerView.addSubview(toView)
        containerView.addSubview(fromView)
        
        var finalFrame = transitionContext.finalFrame(for: fromController)
        finalFrame.origin.y = finalFrame.maxY
        
        let blurView = toView.subview(ofClass: TapVisualEffectView.self)
        
        let animations: TypeAlias.ArgumentlessClosure = {
            
            fromView.frame = finalFrame
            blurView?.style = .none
        }
        
        UIView.animate(withDuration: Constants.animationDuration, animations: animations) { _ in
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
