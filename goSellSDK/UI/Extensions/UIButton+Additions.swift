//
//  UIButton+Additions.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct	TapAdditionsKit.UIButtonAdditions
import class 	UIKit.UIButton.UIButton

internal extension UIButton {
	
	internal func setTitleStyle(_ style: TextStyle) {
		
		self.titleLabel?.font 			= style.font.localized
		self.titleLabel?.textAlignment	= style.alignment.textAlignment
		self.titleLabel?.textColor 		= style.color
	}
}

// MARK: - SingleLocalizable
extension UIButton: SingleLocalizable {
	
	internal func setLocalized(text: String?) {
		
		self.title = text
	}
}
