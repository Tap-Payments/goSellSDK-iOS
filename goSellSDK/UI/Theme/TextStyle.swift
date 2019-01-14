//
//  TextStyle.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class UIKit.NSParagraphStyle.NSMutableParagraphStyle
import class UIKit.NSParagraphStyle.NSParagraphStyle

internal struct TextStyle: Decodable {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal let font: Font
	
	internal let color: HexColor
	
	internal let alignment: LocalizedTextAlignment
	
	internal var asStringAttributes: [NSAttributedString.Key: Any] {
		
		return [
		
			.font: 				self.font.localized,
			.foregroundColor:	self.color,
			.paragraphStyle: 	self.paragraphStyle
		]
	}
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case font 		= "font"
		case color 		= "color"
		case alignment	= "alignment"
	}
	
	// MARK: Properties
	
	private var paragraphStyle: NSParagraphStyle {
		
		let result = NSMutableParagraphStyle()
		result.alignment = self.alignment.textAlignment
		
		return result
	}
}
