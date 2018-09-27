//
//  UIView+Additions.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import enum 	UIKit.UIView.UISemanticContentAttribute
import class	UIKit.UIView.UIView

internal extension UIView {
	
	// MARK: - Internal -
	// MARK: Methods
	
	internal func updateLayoutDirectionIfRequired() {
		
		if #available(iOS 9.0, *) {
			
			let requiredContentAttribute: UISemanticContentAttribute = LocalizationProvider.shared.layoutDirection == .rightToLeft ? .forceRightToLeft : .forceLeftToRight
			if requiredContentAttribute != self.semanticContentAttribute {
				
				self.applySemanticContentAttribute(requiredContentAttribute)
			}
		}
	}
}
