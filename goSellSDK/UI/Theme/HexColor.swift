//
//  HexColor.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class UIKit.UIColor.UIColor

internal final class HexColor: UIColor, Decodable {
	
	required public convenience init(from decoder: Decoder) throws {
		
		let container = try decoder.singleValueContainer()
		let hex = try container.decode(String.self)
		
		self.init(tap_hex: hex)!
	}
}
