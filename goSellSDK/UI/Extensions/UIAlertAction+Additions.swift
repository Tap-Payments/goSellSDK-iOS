//
//  UIAlertAction+Additions.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class UIKit.UIAlertController.UIAlertAction

internal extension UIAlertAction {
	
	internal convenience init(titleKey: LocalizationKey?, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)? = nil) {
		
		var titleText: String? = nil
		if let nonnullTitle = titleKey {
			
			titleText = LocalizationProvider.shared.localizedString(for: nonnullTitle)
		}
		
		self.init(title: titleText, style: style, handler: handler)
	}
}
