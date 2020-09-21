//
//  UINavigationControllerSideAnimationController.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import class    UIKit.UINavigationController.UINavigationController
import class    UIKit.UIView.UIView
import struct   UIKit.UIView.UIViewAnimationOptions
import struct   UIKit.UIView.UIViewKeyframeAnimationOptions
import class    UIKit.UIViewController.UIViewController
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerAnimatedTransitioning
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerContextTransitioning

internal final class UINavigationControllerSideAnimationController: NSObject {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal let operation: UINavigationController.Operation
    internal unowned let fromViewController: UIViewController
    internal unowned let toViewController: UIViewController
    
    // MARK: Methods
    
    internal init(operation: UINavigationController.Operation, from: UIViewController, to: UIViewController) {
        
        self.operation          = operation
        self.fromViewController = from
        self.toViewController   = to
        
        super.init()
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let animationDuration:   TimeInterval    = 0.25
        fileprivate static let minimalAlpha:        CGFloat         = 0.2
        fileprivate static let maximalAlpha:        CGFloat         = 1.0
        
        //@available(*, unavailable) private init() { }
    }
    
    // MARK: Properties
    
    private var willAnimateToTheLeft: Bool {
        
        let layoutDirection = LocalizationManager.shared.layoutDirection
        
        switch self.operation {
            
        case .pop:  return layoutDirection == .rightToLeft
        case .push: return layoutDirection == .leftToRight
        default:    return false

        }
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
extension UINavigationControllerSideAnimationController: UIViewControllerAnimatedTransitioning {
    
    internal func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return Constants.animationDuration
    }
    
    internal func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard self.operation != .none else { return }
        
        let containerView = transitionContext.containerView
        guard let fromView = transitionContext.view(forKey: .from), let toView = transitionContext.view(forKey: .to) else {
            
            transitionContext.completeTransition(false)
            return
        }
        
        var toFrame = toView.frame
        let willMoveToTheLeft = self.willAnimateToTheLeft
        
        if willMoveToTheLeft {
            
            toFrame.origin.x = toFrame.size.width
        } else {
            
            toFrame.origin.x = -toFrame.size.width
        }
        
        toView.frame = toFrame
        
        fromView.alpha = Constants.maximalAlpha
        toView.alpha = Constants.minimalAlpha
        
        containerView.insertSubview(toView, belowSubview: fromView)
        
        let animation = { [weak fromView, weak toView] in
            
            guard let strongFromView = fromView, let strongToView = toView else { return }
            
            var fromFrame = strongFromView.frame
            fromFrame.origin.x = willMoveToTheLeft ? -fromFrame.size.width : fromFrame.size.width
            strongFromView.frame = fromFrame
            strongFromView.alpha = Constants.minimalAlpha
            
            var toFrame2 = strongToView.frame
            toFrame2.origin.x = 0.0
            strongToView.frame = toFrame2
            strongToView.alpha = Constants.maximalAlpha
        }
        
        let animations = {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: animation)
        }
        
        let animationDuration = self.transitionDuration(using: transitionContext)
		let animationOptions: UIView.KeyframeAnimationOptions = [.beginFromCurrentState, UIView.KeyframeAnimationOptions(tap_animationOptions: .curveEaseInOut)]
        UIView.animateKeyframes(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: animations) { (_) in
			
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
