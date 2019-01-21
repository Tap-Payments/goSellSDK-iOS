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
	// MARK: Properties
	
//	internal var tap_topLayoutConstraintToParent: NSLayoutConstraint {
//
//		return self.findOrCreateConstraintToSuperview(with: .top)
//	}
//
//	internal var tap_bottomLayoutConstraintToParent: NSLayoutConstraint {
//
//		return self.findOrCreateConstraintToSuperview(with: .bottom)
//	}
//
//	internal var tap_leftLayoutConstraintToParent: NSLayoutConstraint {
//
//		return self.findOrCreateConstraintToSuperview(with: .left)
//	}
//
//	internal var tap_rightLayoutConstraintToParent: NSLayoutConstraint {
//
//		return self.findOrCreateConstraintToSuperview(with: .right)
//	}
	
	// MARK: Methods
	
	internal func tap_updateLayoutDirectionIfRequired() {
		
		if #available(iOS 9.0, *) {
			
			let requiredContentAttribute: UISemanticContentAttribute = LocalizationProvider.shared.layoutDirection == .rightToLeft ? .forceRightToLeft : .forceLeftToRight
			if requiredContentAttribute != self.semanticContentAttribute {
				
				self.tap_applySemanticContentAttribute(requiredContentAttribute)
			}
		}
	}
	
	internal static func tap_fadeOutUpdateAndFadeIn<T>(view: T, with duration: TimeInterval, delay: TimeInterval = 0.0, update: @escaping (T) -> Void, completion: ((Bool) -> Void)? = nil) where T: UIView {
		
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
	
	// MARK: - Private -
	// MARK: Properties
	
//	private var tap_existingConstraintsToSuperview: [NSLayoutConstraint] {
//
//		guard let nonnullSuperview = self.superview else { return [] }
//
//		return nonnullSuperview.constraints.filter { ($0.firstItem === self && $0.secondItem === self.superview) || ($0.firstItem === self.superview && $0.secondItem === self) }
//	}
//
//	private func findConstraintToSuperview(with attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
//
//		let filtered = self.tap_existingConstraintsToSuperview.filter { $0.firstAttribute == attribute && $0.secondAttribute == attribute }
//		return filtered.first
//	}
//
//	private func createAndAddConstraintToSuperview(with attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint {
//		
//		guard let nonnullSuperview = self.superview else {
//
//			fatalError("The view should have a superview in order to add superview constraints")
//		}
//
//		let constraint = NSLayoutConstraint(item:		self,
//											attribute:	attribute,
//											relatedBy:	.equal,
//											toItem:		nonnullSuperview,
//											attribute:	attribute,
//											multiplier:	1.0,
//											constant:	0.0)
//
//		nonnullSuperview.addConstraint(constraint)
//
//		return constraint
//	}
//
//	private func findOrCreateConstraintToSuperview(with attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint {
//
//		if let existing = self.findConstraintToSuperview(with: attribute) {
//
//			return existing
//		}
//		else {
//
//			return self.createAndAddConstraintToSuperview(with: attribute)
//		}
//	}
}
