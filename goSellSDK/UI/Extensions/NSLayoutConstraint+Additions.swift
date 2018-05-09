//
//  NSLayoutConstraint+Additions.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct TapAdditionsKit.TypeAlias
import class UIKit.NSLayoutConstraint.NSLayoutConstraint
import class UIKit.UIView.UIView

internal extension NSLayoutConstraint {
    
    // MARK: - Internal -
    // MARK: Methods
    
    /// Reactivates layout constraints based on condition.
    ///
    /// - Parameters:
    ///   - condition: Condition.
    ///   - constraintsToDisableOnSuccess: Constraints that will be deactivated if `condition` is `true`, otherwise they will be activated.
    ///   - constraintsToEnableOnSuccess: Constraints that will be activated if `condition` is `true`, otherwise they will be deactivated.
    ///   - viewToLayout: View that will require layout after reactivation.
    ///   - animationDuration: Set `> 0` if reactivation should happen with animation.
    ///   - additionalAnimations: Additional animations.
    internal static func reactivate(inCaseIf condition: Bool, constraintsToDisableOnSuccess: [NSLayoutConstraint], constraintsToEnableOnSuccess: [NSLayoutConstraint], viewToLayout: UIView, animationDuration: TimeInterval, additionalAnimations: TypeAlias.ArgumentlessClosure? = nil) {
        
        var constraintsToDeactivate = condition ? constraintsToDisableOnSuccess : constraintsToEnableOnSuccess
        var constraintsToActivate = condition ? constraintsToEnableOnSuccess : constraintsToDisableOnSuccess
        
        constraintsToDeactivate = constraintsToDeactivate.filter { $0.isActive }
        constraintsToActivate = constraintsToActivate.filter { !$0.isActive }
        
        let hasConstraintsToDeactivate = constraintsToDeactivate.count > 0
        let hasConstraintsToActivate = constraintsToActivate.count > 0
        
        guard hasConstraintsToDeactivate || hasConstraintsToActivate else { return }
        
        let reactivationClosure: TypeAlias.ArgumentlessClosure = {
            
            if hasConstraintsToDeactivate {
                
                self.deactivate(constraintsToDeactivate)
            }
            
            if hasConstraintsToActivate {
                
                self.activate(constraintsToActivate)
            }
            
            viewToLayout.layout()
            
            additionalAnimations?()
        }
        
        if animationDuration > 0.0 {
            
            UIView.animate(withDuration: animationDuration, animations: reactivationClosure)
        }
        else {
            
            UIView.performWithoutAnimation(reactivationClosure)
        }
    }
}
