//
//  UIButton+Additions.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct	TapAdditionsKit.UIButtonAdditions
import class 	UIKit.UIButton.UIButton

extension UIButton: SingleLocalizable {
	
	internal func setLocalized(text: String?) {
		
		self.title = text
	}
}
