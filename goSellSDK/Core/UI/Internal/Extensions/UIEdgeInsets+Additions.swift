//
//  UIEdgeInsets+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	UIKit.UIGeometry.UIEdgeInsets

internal extension UIEdgeInsets {
	
	// MARK: - Internal -
	// MARK: Properties
	
	var tap_localized: UIEdgeInsets {
		
		switch LocalizationManager.shared.layoutDirection {
			
		case .leftToRight: return self
		case .rightToLeft: return self.tap_mirrored
			
		@unknown default:
			
			print("Unknown layout direction to localize edge insets: \(LocalizationManager.shared.layoutDirection)")
			return self
		}
	}
}
