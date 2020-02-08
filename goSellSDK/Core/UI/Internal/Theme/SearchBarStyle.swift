//
//  SearchBarStyle.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal struct SearchBarStyle: Decodable {
	
	// MARK: - Internal -
	// MARK: Properties
	internal var searchHolderBackgroundColor: HexColor
    
	internal let placeholder: TextStyle
	
	internal let text: TextStyle
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case placeholder	                = "placeholder_style"
		case text 			                = "text_style"
        case searchHolderBackgroundColor    = "search_holder_background_color"
	}
}
