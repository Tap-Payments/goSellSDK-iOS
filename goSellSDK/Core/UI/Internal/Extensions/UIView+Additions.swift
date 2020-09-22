//
//  UIView+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	TapAdditionsKitV2.TypeAlias
import enum 	UIKit.UIView.UISemanticContentAttribute
import class	UIKit.UIView.UIView

internal extension UIView {
	
	// MARK: - Internal -	
	// MARK: Methods
	
	func tap_updateLayoutDirectionIfRequired() {
		
		if #available(iOS 9.0, *) {
			
			let requiredContentAttribute: UISemanticContentAttribute = LocalizationManager.shared.layoutDirection == .rightToLeft ? .forceRightToLeft : .forceLeftToRight
			if requiredContentAttribute != self.semanticContentAttribute {
				
				self.tap_applySemanticContentAttribute(requiredContentAttribute)
			}
		}
	}
}
