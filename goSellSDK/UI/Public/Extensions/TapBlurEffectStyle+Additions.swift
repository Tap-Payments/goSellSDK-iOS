//
//  TapBlurEffectStyle+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import enum TapVisualEffectView.TapBlurEffectStyle

extension TapBlurEffectStyle: Decodable {
	
	public init(from decoder: Decoder) throws {
		
		let container = try decoder.singleValueContainer()
		let stringValue = try container.decode(String.self)
		
		self = TapBlurEffectStyle.mapping[stringValue] ?? .none
	}
	
	private static let mapping: [String: TapBlurEffectStyle] = [
	
		"light": 		.light,
		"extra_light":	.extraLight,
		"dark": 		.dark,
		"none": 		.none
	]
}
