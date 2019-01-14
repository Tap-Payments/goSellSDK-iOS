//
//  UIView+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	TapAdditionsKit.TypeAlias
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
	
	internal static func fadeOutUpdateAndFadeIn<T>(view: T, with duration: TimeInterval, delay: TimeInterval = 0.0, update: @escaping (T) -> Void, completion: ((Bool) -> Void)? = nil) where T: UIView {
		
		let fadeDuration = 0.5 * duration
		
		UIView.animate(withDuration:	fadeDuration,
					   delay:			delay,
					   options:			[.beginFromCurrentState, .curveEaseIn],
					   animations:		{ view.alpha = 0.0 }) { (_) in
			
			update(view)
			UIView.animate(withDuration:	fadeDuration,
						   delay:			0.0,
						   options:			[.beginFromCurrentState, .curveEaseOut],
						   animations:		{ view.alpha = 1.0 },
						   completion:		completion)
		}
	}
}
