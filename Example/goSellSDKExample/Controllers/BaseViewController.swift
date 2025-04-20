//
//  BaseViewController.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import ObjectiveC

import Foundation
import func     TapSwiftFixesV2.performOnMainThread
import class    UIKit.NSLayoutConstraint.NSLayoutConstraint
import class    UIKit.UIResponder.UIResponder
import class    UIKit.UIView.UIView
import class    UIKit.UIViewController.UIViewController
import var      UIKit.UIWindow.UIKeyboardAnimationCurveUserInfoKey
import var      UIKit.UIWindow.UIKeyboardAnimationDurationUserInfoKey
import var      UIKit.UIWindow.UIKeyboardFrameEndUserInfoKey

internal class BaseViewController: UIViewController {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal var ignoresKeyboardEventsWhenWindowIsNotKey = false
	
	// MARK: Methods
	
    internal override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if self.topKeyboardOffsetConstraint != nil || self.bottomKeyboardOffsetConstraint != nil {
            
            self.addKeyboardObserver()
        }
    }
    
    internal override func viewDidDisappear(_ animated: Bool) {
        
        if self.topKeyboardOffsetConstraint != nil || self.bottomKeyboardOffsetConstraint != nil {
            
            self.removeKeyboardObserver()
        }
        super.viewDidDisappear(animated)
    }
    
    internal func performAdditionalAnimationsAfterKeyboardLayoutFinished() { }
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var topKeyboardOffsetConstraint: NSLayoutConstraint?
    @IBOutlet private weak var bottomKeyboardOffsetConstraint: NSLayoutConstraint?
    
    // MARK: Methods
    
    private func addKeyboardObserver() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChangeFrame(_:)),
                                               name: .tap_keyboardWillChangeFrameNotificationName,
                                               object: nil)
    }
    
    private func removeKeyboardObserver() {
        
        NotificationCenter.default.removeObserver(self,
                                                  name: .tap_keyboardWillChangeFrameNotificationName,
                                                  object: nil)
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
		
		if let controllerWindow = self.view.window, self.ignoresKeyboardEventsWhenWindowIsNotKey && !controllerWindow.isKeyWindow { return }
		
        performOnMainThread { [weak self] in
            
            guard let strongSelf = self else { return }
            guard let userInfo = notification.userInfo else { return }
            
            guard let window = strongSelf.view.window else { return }
			
			#if swift(>=4.2)
			
			let keyboardFrameEndUserInfoKey				= UIResponder.keyboardFrameEndUserInfoKey
			let keyboardAnimationDurationUserInfoKey	= UIResponder.keyboardAnimationDurationUserInfoKey
			let keyboardAnimationCurveUserInfoKey		= UIResponder.keyboardAnimationCurveUserInfoKey
			
			#else
			
			let keyboardFrameEndUserInfoKey				= UIKeyboardFrameEndUserInfoKey
			let keyboardAnimationDurationUserInfoKey	= UIKeyboardAnimationDurationUserInfoKey
			let keyboardAnimationCurveUserInfoKey		= UIKeyboardAnimationCurveUserInfoKey
			
			#endif
			
            guard var endKeyboardFrame = (userInfo[keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
            
            endKeyboardFrame = window.convert(endKeyboardFrame, to: strongSelf.view)
            
            let screenSize = strongSelf.view.bounds.size
            
            // Fix for cross-fade animation issue
            let offset: CGFloat
            // Check if this might be a cross-fade animation with a zero frame
            if endKeyboardFrame.equalTo(.zero) {
                // For cross-fade animation with zero frame, set offset to 0
                offset = 0.0
            } else if endKeyboardFrame.origin.y > screenSize.height {
                // For regular keyboard hiding animation
                offset = 0.0
            } else {
                offset = max(screenSize.height - endKeyboardFrame.origin.y, 0.0)
            }
            
            let keyboardIsShown = offset > 0.0
            
            let animationDuration = (userInfo[keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.0
            var animationCurve: UIView.AnimationOptions
            if let animationCurveRawValue = ((userInfo[keyboardAnimationCurveUserInfoKey]) as? NSNumber)?.intValue {
                
                let allPossibleCurves: [UIView.AnimationCurve] = [.easeInOut, .easeIn, .easeOut, .linear]
                let allPossibleRawValues = allPossibleCurves.map { $0.rawValue }
				
                if allPossibleRawValues.contains(animationCurveRawValue), let curve = UIView.AnimationCurve(rawValue: animationCurveRawValue) {
                    
					animationCurve = UIView.AnimationOptions(tap_curve: curve)
                }
                else {
                    
                    animationCurve = keyboardIsShown ? .curveEaseOut : .curveEaseIn
                }
            }
            else {
                
                animationCurve = keyboardIsShown ? .curveEaseOut : .curveEaseIn
            }
            
            let animationOptions: UIView.AnimationOptions = [
                
                .beginFromCurrentState,
                animationCurve
            ]
            
            let animations = { [weak strongSelf] in
                
                guard let strongerSelf = strongSelf else { return }
                
                strongerSelf.topKeyboardOffsetConstraint?.constant = -offset
                strongerSelf.bottomKeyboardOffsetConstraint?.constant = offset
                
                strongerSelf.view.tap_layout()
                
                strongerSelf.performAdditionalAnimationsAfterKeyboardLayoutFinished()
            }
            
            UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: animations, completion: nil)
        }
    }
}
