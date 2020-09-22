//
//  UIButton+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	TapAdditionsKitV2.UIButton

internal extension UIButton {
	
	func setTitleStyle(_ style: TextStyle) {
		
		self.titleLabel?.font 			= style.font.localized
		self.titleLabel?.textAlignment	= style.alignment.textAlignment
		self.titleLabel?.textColor 		= style.color.color
	}
}

// MARK: - SingleLocalizable
extension UIButton: SingleLocalizable {
	
	internal func setLocalized(text: String?) {
		
		self.tap_title = text
	}
}
