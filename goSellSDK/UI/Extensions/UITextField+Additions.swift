//
//  UITextField+Additions.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class UIKit.UITextField.UITextField

extension UITextField: Localizable {
	
	// MARK: - Internal -
	
	internal enum LocalizableElement {
		
		case text
		case placeholder
	}
	
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
	
	internal func setLocalized(text: String?, for element: LocalizableElement) {
		
		switch element {
			
		case .text: 		self.text = text
		case .placeholder:	self.placeholder = text

		}
	}
}
