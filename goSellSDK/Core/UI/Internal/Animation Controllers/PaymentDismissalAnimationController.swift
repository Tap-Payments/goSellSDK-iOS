//
//  PaymentDismissalAnimationController.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	TapAdditionsKitV2.TypeAlias
import class	TapVisualEffectViewV2.TapVisualEffectView
import class	UIKit.UIDevice.UIDevice
import class	UIKit.UIView.UIView
import struct	UIKit.UIView.UIViewAnimationOptions
import protocol	UIKit.UIViewControllerTransitioning.UIViewControllerAnimatedTransitioning
import protocol	UIKit.UIViewControllerTransitioning.UIViewControllerContextTransitioning
import class	UIKit.UIViewPropertyAnimator.UIViewPropertyAnimator

internal final class PaymentDismissalAnimationController: NSObject {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal static var usesFadeAnimation: Bool = false
	
	internal var additionalAnimations: TypeAlias.ArgumentlessClosure?
    
    // MARK: Methods
    
    internal init(animateBlur: Bool = true) {
        
        self.animatesBlur = animateBlur
        
        super.init()
    }
	
	deinit {
		
		self.additionalAnimations = nil
	}
	
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let animationDuration: TimeInterval = 0.4
        
        //@available(*, unavailable) private init() { }
    }
    
    // MARK: Properties
    
    private let animatesBlur: Bool
	
	private var _blurAnimator: Any?
	
	@available(iOS 10.0, *)
	private var blurAnimator: UIViewPropertyAnimator? {
		
		get {
			
			return self._blurAnimator as? UIViewPropertyAnimator
		}
		set {
			
			self._blurAnimator = newValue
		}
	}
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
			
			if UIDevice.current.tap_isRunningIOS9OrLower {
				
				blurView?.style = .none
			}
			
			self.additionalAnimations?()
        }
		
		if #available(iOS 10.0, *) {
			
			let blurStyle = Theme.current.commonStyle.blurStyle[Process.shared.appearance]
			
			let animationDuration = TimeInterval(blurStyle.progress > 0 ? 1.0 / blurStyle.progress : 0.0) * Constants.animationDuration
			
			self.blurAnimator = UIViewPropertyAnimator(duration: animationDuration, curve: .linear) {
				
				blurView?.style = .none
			}
			
			self.blurAnimator?.fractionComplete = 1.0 - blurStyle.progress
			
			self.blurAnimator?.startAnimation()
		}
        
        let options: UIView.AnimationOptions = [.beginFromCurrentState, .curveEaseIn]
        UIView.animate(withDuration: Constants.animationDuration, delay: 0.0, options: options, animations: animations) { _ in
			
			if #available(iOS 10.0, *) {
				
				self.blurAnimator?.stopAnimation(true)
			}
			
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
