//
//  SeparateWindowViewController+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	TapAdditionsKit.SeparateWindowRootViewController
import class	UIKit.UIApplication.UIApplication
import enum		UIKit.UIApplication.UIStatusBarStyle

public extension SeparateWindowRootViewController {
	
	// MARK: - Public -
	// MARK: Properties
	
	public override var preferredStatusBarStyle: UIStatusBarStyle {
		
		return UIApplication.shared.statusBarStyle
	}
	
	public override var modalPresentationCapturesStatusBarAppearance: Bool {
		
		get {
			
			return false
		}
		set {
			
			super.modalPresentationCapturesStatusBarAppearance = false
		}
	}
}
