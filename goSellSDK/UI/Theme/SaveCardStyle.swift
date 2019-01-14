//
//  SaveCardStyle.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal struct SaveCardStyle: Decodable {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal let textStyle: TextStyle
	
	internal let switchOnTintColor: HexColor
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case textStyle 			= "text_style"
		case switchOnTintColor	= "switch_on_tint_color"
	}
}
