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
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerAnimatedTransitioning
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerContextTransitioning

internal class PaymentPresentationAnimationController: NSObject {
    
    // MARK: - Internal -
    
    internal init(startFrame: CGRect) {
        
        self.startFrame = startFrame
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let animationDuration: TimeInterval = 2.0
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
    
    private let startFrame: CGRect
}

extension PaymentPresentationAnimationController: UIViewControllerAnimatedTransitioning {
    
    internal func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return Constants.animationDuration
    }
    
    internal func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard
            
            let fromController = transitionContext.viewController(forKey: .from),
            let toController = transitionContext.viewController(forKey: .to),
            let toView = toController.view
        
        else { return }
        
        let containerView = transitionContext.containerView
        
        containerView.addSubview(toView)
        
        let finalFrame = transitionContext.finalFrame(for: toController)
        
        var startFrame = finalFrame
        startFrame.origin.y = finalFrame.maxY
        
        toView.frame = startFrame
        
        let blurView = toView.subview(ofClass: TapVisualEffectView.self)
        blurView?.style = .none
        
        let animations: TypeAlias.ArgumentlessClosure = {
            
            toView.frame = finalFrame
            blurView?.style = Theme.current.settings.backgroundBlurStyle
        }
        
        UIView.animate(withDuration: Constants.animationDuration, animations: animations) { _ in
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
