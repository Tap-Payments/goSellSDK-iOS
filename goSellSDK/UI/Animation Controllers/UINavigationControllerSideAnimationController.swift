//
//  UINavigationControllerSideAnimationController.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import enum     UIKit.UINavigationController.UINavigationControllerOperation
import class    UIKit.UIView.UIView
import struct   UIKit.UIView.UIViewAnimationOptions
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerAnimatedTransitioning
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerContextTransitioning

internal class UINavigationControllerSideAnimationController: NSObject {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal init(operation: UINavigationControllerOperation) {
        
        self.operation = operation
        super.init()
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let animationDuration: TimeInterval = 0.25
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
    
    private let operation: UINavigationControllerOperation
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
        let layoutDirection = SettingsDataManager.shared.layoutDirection
        let willMoveToTheLeft = (self.operation == .push && layoutDirection == .leftToRight) || (self.operation == .pop && layoutDirection == .rightToLeft)
        
        if willMoveToTheLeft {
            
            toFrame.origin.x = toFrame.size.width
        } else {
            
            toFrame.origin.x = -toFrame.size.width
        }
        
        toView.frame = toFrame
        
        containerView.insertSubview(toView, belowSubview: fromView)
        
        let animations = { [weak fromView, weak toView] in
            
            guard let strongFromView = fromView, let strongToView = toView else { return }
            
            var fromFrame = strongFromView.frame
            fromFrame.origin.x = willMoveToTheLeft ? -fromFrame.size.width : fromFrame.size.width
            strongFromView.frame = fromFrame
            
            var toFrame2 = strongToView.frame
            toFrame2.origin.x = 0.0
            strongToView.frame = toFrame2
        }
        
        let animationOptions: UIViewAnimationOptions = [.beginFromCurrentState, .curveEaseInOut]
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0.0, options: animationOptions, animations: animations) { (finished) in
            
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
}
