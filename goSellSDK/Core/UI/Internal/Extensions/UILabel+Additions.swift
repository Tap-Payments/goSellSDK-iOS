//
//  UILabel+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	UIKit.UILabel.UILabel

extension UILabel {
	
	internal func setTextStyle(_ textStyle: TextStyle) {
        DispatchQueue.main.async {
            self.textAlignment	= textStyle.alignment.textAlignment
            self.font 			= textStyle.font.localized
            self.textColor	 	= textStyle.color.color
        }
	}
}

extension UILabel: SingleLocalizable {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal var tap_localizedTextAlignment: LocalizedTextAlignment {
		
		get {
			
			return self.textAlignment.tap_localizedTextAlignment
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
