//
//  UILabel+Additions.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class	UIKit.UILabel.UILabel

extension UILabel: SingleLocalizable {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal var localizedTextAlignment: LocalizedTextAlignment {
		
		get {
			
			return self.textAlignment.localizedTextAlignment
		}
		set {
			
			self.textAlignment = newValue.textAlignment
		}
	}
	
	// MARK: Methods
	
	internal func setLocalized(text: String?) {
		
		self.text = text
	}
}
