//
//  PaymentDismissalAnimationController.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct TapAdditionsKit.TypeAlias
import class TapVisualEffectView.TapVisualEffectView
import class UIKit.UIView.UIView
import struct UIKit.UIView.UIViewAnimationOptions
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerAnimatedTransitioning
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerContextTransitioning

internal final class PaymentDismissalAnimationController: NSObject {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal static var usesFadeAnimation: Bool = false
    
    // MARK: Methods
    
    internal init(animateBlur: Bool = true) {
        
        self.animatesBlur = animateBlur
        
        super.init()
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let animationDuration: TimeInterval = 0.4
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
    
    private let animatesBlur: Bool
}

// MARK: - UIViewControllerAnimatedTransitioning
extension PaymentDismissalAnimationController: UIViewControllerAnimatedTransitioning {
    
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
        
        containerView.addSubview(toView)
        containerView.addSubview(fromView)
        
        var finalFrame = transitionContext.finalFrame(for: fromController)
        
        if !type(of: self).usesFadeAnimation {
        
            finalFrame.origin.y = finalFrame.maxY
        }
        
        let blurView = self.animatesBlur ? toView.tap_subview(ofClass: TapVisualEffectView.self) : nil
        
        let animations: TypeAlias.ArgumentlessClosure = {
            
            if type(of: self).usesFadeAnimation {
                
                fromView.alpha = 0.0
            }
            else {
                
                fromView.frame = finalFrame
            }
            
            blurView?.style = .none
        }
        
        let options: UIView.AnimationOptions = [.beginFromCurrentState, .curveEaseIn]
        UIView.animate(withDuration: Constants.animationDuration, delay: 0.0, options: options, animations: animations) { _ in
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
