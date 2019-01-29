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
	
	internal var tap_localized: UIEdgeInsets {
		
		switch LocalizationProvider.shared.layoutDirection {
			
		case .leftToRight: return self
		case .rightToLeft: return self.tap_mirrored
			
		}
	}
}
