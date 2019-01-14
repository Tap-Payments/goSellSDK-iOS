//
//  UITextField+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class UIKit.UITextField.UITextField

internal extension UITextField {
	
	internal func setTextStyle(_ textStyle: TextStyle, _ placeholderStyle: TextStyle) {
		
		let attributedPlaceholder = NSAttributedString(string: self.placeholder ?? .empty, attributes: placeholderStyle.asStringAttributes)
		self.attributedPlaceholder = attributedPlaceholder
		
		self.font 					= textStyle.font.localized
		self.localizedTextAlignment	= textStyle.alignment
		self.textColor 				= textStyle.color
	}
}

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
			
		case .text:
			
			if let nonnullAttributedText = self.attributedText {
				
				let mutableText = NSMutableAttributedString(attributedString: nonnullAttributedText)
				mutableText.replaceCharacters(in:	NSRange(location: 0, length: mutableText.length),
											  with:	text ?? .empty)
				self.attributedText = NSAttributedString(attributedString: mutableText)
			}
			else {
				
				self.text = text
			}
			
			
		case .placeholder:
			
			if let nonnullAttributedPlaceholder = self.attributedPlaceholder {
				
				let mutablePlaceholder = NSMutableAttributedString(attributedString: nonnullAttributedPlaceholder)
				mutablePlaceholder.replaceCharacters(in:	NSRange(location: 0, length: mutablePlaceholder.length),
													 with:	text ?? .empty)
				self.attributedPlaceholder = NSAttributedString(attributedString: mutablePlaceholder)
			}
			else {
				
				self.placeholder = text
			}

		}
	}
}
