//
//  PopupAnimationController.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import struct   TapAdditionsKitV2.TypeAlias
import class    UIKit.UIView.UIView
import struct   UIKit.UIView.UIViewKeyframeAnimationOptions
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerAnimatedTransitioning
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerContextTransitioning

internal final class PopupAnimationController: NSObject {
    
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
        
        fileprivate static let animationDuration:       TimeInterval    = 0.8
        fileprivate static let moveDownDuration:        TimeInterval    = 0.3
        fileprivate static let middleFrameBottomOffset: CGFloat         = 8.0
        
        //@available(*, unavailable) private init() { }
    }
    
    private struct PopupAnimationParameters {
        
        fileprivate unowned let viewToMove: UIView
        fileprivate let initialFrame:       CGRect
        fileprivate let middleFrame:        CGRect
        fileprivate let finalFrame:         CGRect
        
        fileprivate init(viewToMove: UIView, initialFrame: CGRect, middleFrame: CGRect, finalFrame: CGRect) {
            
            self.viewToMove     = viewToMove
            self.initialFrame   = initialFrame
            self.middleFrame    = middleFrame
            self.finalFrame     = finalFrame
        }
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
extension PopupAnimationController: UIViewControllerAnimatedTransitioning {
    
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
        
        if self.operation == .presentation {
            
            containerView.addSubview(fromView)
            containerView.addSubview(toView)
        }
        else {
            
            containerView.addSubview(toView)
            containerView.addSubview(fromView)
        }
        
        guard let animationParameters = self.popupAnimationParameters(from: transitionContext) else { return }
        let viewToMove = animationParameters.viewToMove
        viewToMove.frame = animationParameters.initialFrame
        
        let animationDuration = self.transitionDuration(using: transitionContext)
        
		let easeInOutOption = UIView.KeyframeAnimationOptions(tap_animationOptions: .curveEaseInOut)
        let animationOptions: UIView.KeyframeAnimationOptions = [.beginFromCurrentState, easeInOutOption]
        let animations: TypeAlias.ArgumentlessClosure = {
            
            let firstAnimationTime = self.operation == .dismissal ? Constants.moveDownDuration : 1.0 - Constants.moveDownDuration
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: firstAnimationTime) {
                
                viewToMove.frame = animationParameters.middleFrame
            }
            
            UIView.addKeyframe(withRelativeStartTime: firstAnimationTime, relativeDuration: Constants.moveDownDuration) {
                
                viewToMove.frame = animationParameters.finalFrame
            }
        }
        
        UIView.animateKeyframes(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: animations) { (finished) in
            
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
    
    private func popupAnimationParameters(from context: UIViewControllerContextTransitioning) -> PopupAnimationParameters? {
        
        guard
            
            let fromController  = context.viewController(forKey: .from),
            let toController    = context.viewController(forKey: .to),
            let fromView        = fromController.view,
            let toView          = toController.view
            
        else { return nil }
        
        if self.operation == .presentation {
            
            guard let separateWindowController = toController as? SeparateWindowViewController else { return nil }
            let contentHeight = separateWindowController.mask.bounds.height
            let contentTopOffset = separateWindowController.mask.frame.origin.y
            
            let finalFrame = context.finalFrame(for: toController)
            let middleFrame = finalFrame.offsetBy(dx: 0.0, dy: Constants.middleFrameBottomOffset)
            let initialFrame = CGRect(origin: CGPoint(x: finalFrame.origin.x, y: -(contentHeight + contentTopOffset)), size: finalFrame.size)
            
            return PopupAnimationParameters(viewToMove: toView, initialFrame: initialFrame, middleFrame: middleFrame, finalFrame: finalFrame)
        }
        else {
            
            guard let separateWindowController = fromController as? SeparateWindowViewController else { return nil }
            let contentHeight = separateWindowController.mask.bounds.height
            let contentTopOffset = separateWindowController.mask.frame.origin.y
            
            var finalFrame = context.finalFrame(for: fromController)
            finalFrame.origin = CGPoint(x: finalFrame.origin.x, y: -abs(contentHeight + contentTopOffset))
            let initialFrame = CGRect(origin: .zero, size: finalFrame.size)
            let middleFrame = initialFrame.offsetBy(dx: 0.0, dy: Constants.middleFrameBottomOffset)
            
            return PopupAnimationParameters(viewToMove: fromView, initialFrame: initialFrame, middleFrame: middleFrame, finalFrame: finalFrame)
        }
    }
}
