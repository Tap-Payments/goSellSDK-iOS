//
//  UIWindow.Level+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	UIKit.UIWindow.UIWindow

#if !swift(>=4.2)
import var		UIKit.UIWindow.UIWindowLevelStatusBar
#endif

internal extension UIWindow.Level {
	
	static var tap_statusBar: UIWindow.Level {
		
		#if swift(>=4.2)
		return .statusBar
		#else
		return UIWindowLevelStatusBar
		#endif
	}
}
