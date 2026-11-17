//
//  SeparateWindowViewController+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
import UIKit
import class	TapAdditionsKitV2.SeparateWindowRootViewController
import class	UIKit.UIApplication.UIApplication
import enum		UIKit.UIApplication.UIStatusBarStyle

public extension SeparateWindowRootViewController {
	
	// MARK: - Public -
	// MARK: Properties
	
	/// Preferred status bar style.
	override var preferredStatusBarStyle: UIStatusBarStyle {
		
		return UIApplication.shared.statusBarStyle
	}
	
	/// Defines if modal presentation of the receiver captures status bar appearance.
	override var modalPresentationCapturesStatusBarAppearance: Bool {
		
		get {
			
			return false
		}
		set {
			
			super.modalPresentationCapturesStatusBarAppearance = false
		}
	}
}
