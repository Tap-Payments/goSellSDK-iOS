//
//  TextInputStyle.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal struct TextInputStyle: Decodable {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal let valid: TextStyle
	
	internal let invalid: TextStyle
	
	internal let placeholder: TextStyle
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case valid 			= "valid"
		case invalid 		= "invalid"
		case placeholder	= "placeholder"
	}
}
