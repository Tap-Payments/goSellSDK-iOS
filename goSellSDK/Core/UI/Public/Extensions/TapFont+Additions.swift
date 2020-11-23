//
//  TapFont+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import enum TapFontsKitV2.TapFont

// MARK: - Decodable
extension TapFont: Decodable {
	
	public init(from decoder: Decoder) throws {
		
		let container = try decoder.singleValueContainer()
		let stringValue = try container.decode(String.self)
		
		guard let result = TapFont.mappingTable[stringValue] else {
			
			fatalError("Unknown font: \(stringValue)")
		}
		
		self = result
	}
	
	// MARK: - Private -
	
	private static let mappingTable: [String: TapFont] = [
		
		"helvetica-neue-thin": 			.helveticaNeueThin,
		"helvetica-neue-light": 		.helveticaNeueLight,
		"helvetica-neue-medium": 		.helveticaNeueMedium,
		"helvetica-neue-regular": 		.helveticaNeueRegular,
		"helvetica-neue-bold": 			.helveticaNeueBold,
		"helvetica-neue-light-ar": 		.arabicHelveticaNeueLight,
		"helvetica-neue-regular-ar":	.arabicHelveticaNeueRegular,
		"helvetica-neue-bold-ar": 		.arabicHelveticaNeueBold,
	]
}
