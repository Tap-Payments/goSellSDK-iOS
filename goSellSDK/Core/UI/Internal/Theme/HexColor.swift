//
//  HexColor.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class UIKit.UIColor.UIColor

internal struct HexColor {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal let color: UIColor
	
	// MARK: Methods
	
	internal init(hex: String) {
		
		self.init(color: UIColor(tap_hex: hex)!)
	}
	
	internal init(color: UIColor) {
		
		self.color = color
	}
}

extension HexColor: Decodable {
	
	internal init(from decoder: Decoder) throws {
		
		let container = try decoder.singleValueContainer()
		let hex = try container.decode(String.self)
		
		self.init(hex: hex)
	}
}
