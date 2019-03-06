//
//  UIColor+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	UIKit.UIColor.UIColor

internal extension UIColor {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal var tap_asHexColor: HexColor {
		
		return HexColor(tap_rgba: self.tap_rgbaComponents!)!
	}
}
