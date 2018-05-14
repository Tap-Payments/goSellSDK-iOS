//
//  PaymentPresentationAnimationController.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct CoreGraphics.CGGeometry.CGRect
import struct TapAdditionsKit.TypeAlias
import class TapVisualEffectView.TapVisualEffectView
import class UIKit.UIView.UIView
import struct UIKit.UIView.UIViewAnimationOptions
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerAnimatedTransitioning
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerContextTransitioning

internal class PaymentPresentationAnimationController: NSObject {
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let animationDuration: TimeInterval = 0.4
        
        @available(*, unavailable) private init() {}
    }
}

extension PaymentPresentationAnimationController: UIViewControllerAnimatedTransitioning {
    
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
        
        containerView.addSubview(fromView)
        containerView.addSubview(toView)
        
        let finalFrame = transitionContext.finalFrame(for: toController)
        
        var startFrame = finalFrame
        startFrame.origin.y = finalFrame.maxY
        
        toView.frame = startFrame
        
        let blurView = fromView.subview(ofClass: TapVisualEffectView.self)
        blurView?.style = .none
        
        let animations: TypeAlias.ArgumentlessClosure = {
            
            toView.frame = finalFrame
            blurView?.style = Theme.current.settings.backgroundBlurStyle
        }
        
        let options: UIViewAnimationOptions = [.beginFromCurrentState, .curveEaseOut]
        UIView.animate(withDuration: Constants.animationDuration, delay: 0.0, options: options, animations: animations) { _ in
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
