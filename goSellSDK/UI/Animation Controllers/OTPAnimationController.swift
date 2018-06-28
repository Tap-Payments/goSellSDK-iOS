//
//  OTPAnimationController.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct   CoreGraphics.CGBase.CGFloat
import struct   TapAdditionsKit.TypeAlias
import class    TapVisualEffectView.TapVisualEffectView
import class    UIKit.UIColor.UIColor
import class    UIKit.UIResponder.UIResponder
import class    UIKit.UIView.UIView
import struct   UIKit.UIView.UIViewKeyframeAnimationOptions
import class    UIKit.UIViewController.UIViewController
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerAnimatedTransitioning
import protocol UIKit.UIViewControllerTransitioning.UIViewControllerContextTransitioning

internal class OTPAnimationController: NSObject {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal unowned let fromViewController: UIViewController
    internal unowned let toViewController: UIViewController
    
    // MARK: Methods
    
    internal init(operation: ViewControllerOperation, from: UIViewController, to: UIViewController) {
        
        self.operation          = operation
        self.fromViewController = from
        self.toViewController   = to
        
        super.init()
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let animationDuration: TimeInterval = 0.4
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
    
    private let operation: ViewControllerOperation
    
    private weak var firstResponderOnMomentOfDismissal: UIResponder?
}

// MARK: - UIViewControllerAnimatedTransitioning
extension OTPAnimationController: UIViewControllerAnimatedTransitioning {
    
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
        
        var nullableOTPController: OTPViewController?
        let containerView = transitionContext.containerView
        
        switch self.operation {
            
        case .presentation:
            
            containerView.addSubview(fromView)
            containerView.addSubview(toView)
            
            nullableOTPController = toController as? OTPViewController
            
        case .dismissal:
            
            containerView.addSubview(toView)
            containerView.addSubview(fromView)
            
            nullableOTPController = fromController as? OTPViewController
        }
        
        guard let otpController = nullableOTPController, let otpView = otpController.view else { return }
        
        let finalFrame = transitionContext.finalFrame(for: otpController)
        otpView.frame = finalFrame
        
        var initialConstant: CGFloat
        var finalConstant: CGFloat
        var initialAlpha: CGFloat
        
        if self.operation == .presentation {
            
            initialConstant = finalFrame.height
            finalConstant = 0.0
            initialAlpha = 0.0
        }
        else {
            
            initialConstant = 0.0
            finalConstant = finalFrame.height
            initialAlpha = 1.0
        }
        
        otpView.alpha = initialAlpha
        
        otpController.presentationAnimationAnimatingConstraint?.constant = initialConstant
        otpView.layout()
        
        let backgroundColor = otpView.layer.backgroundColor
        if self.operation == .presentation {
            
            otpView.layer.backgroundColor = UIColor.clear.cgColor
        }
        
        let blurView = otpView.subview(ofClass: TapVisualEffectView.self)
        blurView?.style = self.operation == .presentation ? .none : .light
        
        let animations: TypeAlias.ArgumentlessClosure = {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0) {
                
                if self.operation == .presentation {
                    
                    otpView.layer.backgroundColor = backgroundColor
                    otpView.alpha = 1.0
                    blurView?.style = .light
                }
                else {
                    
                    otpView.layer.backgroundColor = UIColor.clear.cgColor
                    otpView.alpha = 1.0
                    blurView?.style = .none
                }
                
                otpController.presentationAnimationAnimatingConstraint?.constant = finalConstant
                otpView.layout()
            }
        }
        
        let animationDuration = self.transitionDuration(using: transitionContext)
        let animationOption = UIViewKeyframeAnimationOptions(self.operation == .presentation ? .curveEaseOut : .curveEaseIn)
        let animationOptions: UIViewKeyframeAnimationOptions = [.beginFromCurrentState, animationOption]
        
        UIView.animateKeyframes(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: animations) { (finished) in
            
            let success = finished && !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(success)
        }
    }
}

// MARK: - InteractiveTransitionControllerStatusReporting
extension OTPAnimationController: InteractiveTransitionControllerStatusReporting {
    
    internal func interactiveTransitionWillCancel() {
        
        guard let otpController = self.fromViewController as? OTPViewController else { return }
        
        self.firstResponderOnMomentOfDismissal = otpController.view.firstResponder
    }
    
    internal func interactiveTransitionDidCancel() {
        
        guard self.operation == .dismissal, let otpController = self.fromViewController as? OTPViewController else { return }
        
        let animations: TypeAlias.ArgumentlessClosure = {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0) {
             
                otpController.presentationAnimationAnimatingConstraint?.constant = 0.0
                self.firstResponderOnMomentOfDismissal?.becomeFirstResponder()
            }
        }
        
        let animationDuration = self.transitionDuration(using: nil)
        let animationOption = UIViewKeyframeAnimationOptions(self.operation == .presentation ? .curveEaseOut : .curveEaseIn)
        let animationOptions: UIViewKeyframeAnimationOptions = [.beginFromCurrentState, animationOption]
        
        UIView.animateKeyframes(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: animations, completion: nil)
    }
}
