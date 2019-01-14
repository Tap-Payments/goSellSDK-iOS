//
//  UIAlertController+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class UIKit.UIAlertController.UIAlertController

extension UIAlertController: Localizable {
	
	internal convenience init(titleKey: LocalizationKey?, messageKey: LocalizationKey?, preferredStyle: Style) {
		
		self.init(titleKey: titleKey, messageKey: messageKey, [], preferredStyle: preferredStyle)
	}
	
	internal convenience init(titleKey: LocalizationKey?, messageKey: LocalizationKey?, _ messageArguments: CVarArg..., preferredStyle: Style) {
		
		self.init(title: nil, message: nil, preferredStyle: preferredStyle)
		self.setLocalizedText(for: .title, key: titleKey)
		
		if messageArguments.count > 0 {
		
			self.setLocalizedText(for: .message, key: messageKey, arguments: messageArguments)
		}
		else {
			
			self.setLocalizedText(for: .message, key: messageKey)
		}
	}
	
	internal func setLocalized(text: String?, for element: LocalizableElement) {
		
		switch element {
			
		case .title:	self.title 		= text
		case .message: 	self.message	= text

		}
	}
	
	internal enum LocalizableElement {
		
		case title
		case message
	}
}
