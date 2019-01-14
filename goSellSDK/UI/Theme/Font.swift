//
//  Font.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	CoreGraphics.CGBase.CGFloat
import enum 	TapFontsKit.TapFont
import class	UIKit.UIFont.UIFont

internal struct Font: Decodable {
	
	// MARK: - Internal -
	// MARK: Properties
	
	let font: TapFont
	let size: CGFloat
	
	internal var localized: UIFont {
		
		return self.font.localizedWithSize(self.size, languageIdentifier: LocalizationProvider.shared.selectedLanguage)
	}
	
	// MARK: Methods
	
	internal init(_ font: TapFont, _ size: CGFloat) {
		
		self.font = font
		self.size = size
	}
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case font = "typeface"
		case size = "size"
	}
}
