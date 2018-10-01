//
//  SearchBarStyle.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal struct SearchBarStyle: Decodable {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal let placeholder: TextStyle
	
	internal let text: TextStyle
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case placeholder	= "placeholder_style"
		case text 			= "text_style"
	}
}
