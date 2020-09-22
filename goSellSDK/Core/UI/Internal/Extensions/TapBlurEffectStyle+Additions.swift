//
//  TapBlurEffectStyle+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import enum		TapVisualEffectViewV2.TapBlurEffectStyle
import class	UIKit.UIBlurEffect.UIBlurEffect

internal extension TapBlurEffectStyle {
	
	// MARK: - Internal -
	// MARK: Methods
	
	init(_ style: UIBlurEffect.Style) {
		
		switch style {
			
		case .light:		self = .light
		case .extraLight:	self = .extraLight
		case .dark:			self = .dark
		case .prominent:
			
			if #available(iOS 10.0, *) {
				
				self = .prominent
			}
			else {
				
				self = .extraLight
			}
			
		case .regular:
			
			if #available(iOS 10.0, *) {
				
				self = .regular
			}
			else {
				
				self = .light
			}
		@unknown default:
			
			self = .light
		}
	}
}

// MARK: - Decodable
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
