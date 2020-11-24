//
//  BaseViewController.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import func     TapSwiftFixesV2.performOnMainThread
import enum     UIKit.UIApplication.UIInterfaceOrientation
import struct   UIKit.UIApplication.UIInterfaceOrientationMask
import class    UIKit.NSLayoutConstraint.NSLayoutConstraint
import class    UIKit.UIResponder.UIResponder
import class    UIKit.UIView.UIView
import enum     UIKit.UIView.UIViewAnimationCurve
import struct   UIKit.UIView.UIViewAnimationOptions
import class    UIKit.UIViewController.UIViewController
import var      UIKit.UIWindow.UIKeyboardAnimationCurveUserInfoKey
import var      UIKit.UIWindow.UIKeyboardAnimationDurationUserInfoKey
import var      UIKit.UIWindow.UIKeyboardFrameEndUserInfoKey

/// Base View Controller.
internal class BaseViewController: UIViewController, LocalizationObserver, LayoutDirectionObserver, ThemeObserver {
	
    // MARK: - Internal -
    // MARK: Properties
	
	internal override var modalPresentationCapturesStatusBarAppearance: Bool {
		
		get {
			
			return true
		}
		set {
			
			super.modalPresentationCapturesStatusBarAppearance = true
		}
	}
	
	internal var ignoresKeyboardEventsWhenWindowIsNotKey = false
	
    internal override var shouldAutorotate: Bool {
        
        return InterfaceOrientationManager.shared.viewControllerShouldAutorotate(self)
    }
    
    internal override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        return InterfaceOrientationManager.shared.supportedInterfaceOrientations(for: self)
    }
    
    internal override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        
        return InterfaceOrientationManager.shared.preferredInterfaceOrientationForPresentation(of: self)
    }
	
	internal var viewToUpdateLayoutDirection: UIView { return self.view }
    
    // MARK: Methods

    internal override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if self.topKeyboardOffsetConstraint != nil || self.bottomKeyboardOffsetConstraint != nil {
            
            self.addKeyboardObserver()
        }
		
		self.localizationChanged()
		self.localizationObserver = self.startMonitoringLocalizationChanges()
		
		self.view.tap_updateLayoutDirectionIfRequired()
		self.layoutDirectionObserver = self.startMonitoringLayoutDirectionChanges()
		
		self.themeChanged()
		self.themeObserver = self.startMonitoringThemeChanges()
		
		self.setNeedsStatusBarAppearanceUpdate()
    }
    
    internal override func viewDidDisappear(_ animated: Bool) {
        
        if self.topKeyboardOffsetConstraint != nil || self.bottomKeyboardOffsetConstraint != nil {
            
            self.removeKeyboardObserver()
			self.keyboardObserver = nil
        }
		
		self.stopMonitoringLocalizationChanges(self.localizationObserver)
		self.localizationObserver = nil
		
		self.stopMonitoringLayoutDirectionChanges(self.layoutDirectionObserver)
		self.layoutDirectionObserver = nil
		
		self.stopMonitoringThemeChanges(self.themeObserver)
		self.themeObserver = nil
		
        super.viewDidDisappear(animated)
    }
    
    internal func performAdditionalAnimationsAfterKeyboardLayoutFinished() { }
	
	internal func localizationChanged() {}
	internal func themeChanged() {}
	
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var topKeyboardOffsetConstraint: NSLayoutConstraint?
    @IBOutlet private weak var bottomKeyboardOffsetConstraint: NSLayoutConstraint?
	
	private var keyboardObserver: NSObjectProtocol?
	private var localizationObserver: NSObjectProtocol?
	private var themeObserver: NSObjectProtocol?
	private var layoutDirectionObserver: NSObjectProtocol?
	
    // MARK: Methods
    
    private func addKeyboardObserver() {
		
		guard self.keyboardObserver == nil else { return }
		
		self.keyboardObserver = NotificationCenter.default.addObserver(forName: .tap_keyboardWillChangeFrameNotificationName, object: nil, queue: .main) { [weak self] (notification) in
			
			self?.keyboardWillChangeFrame(notification)
		}
    }
	
	private func removeKeyboardObserver() {
		
		guard let nonnullKeyboardObserver = self.keyboardObserver else { return }
		
		NotificationCenter.default.removeObserver(nonnullKeyboardObserver, name: .tap_keyboardWillChangeFrameNotificationName, object: nil)
	}
    
	private func keyboardWillChangeFrame(_ notification: Notification) {
		
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
			
			let offset = max(screenSize.height - endKeyboardFrame.origin.y, 0.0)
			let keyboardIsShown = offset > 0.0
			
			if let controllerWindow = self?.view.window, keyboardIsShown && (self?.ignoresKeyboardEventsWhenWindowIsNotKey ?? false) && !controllerWindow.isKeyWindow { return }
			
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
