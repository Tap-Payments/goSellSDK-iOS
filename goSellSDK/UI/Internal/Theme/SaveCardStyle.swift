//
//  SaveCardStyle.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal struct SaveCardStyle: Decodable {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal var textStyle: TextStyle
	
	internal var switchOnTintColor: HexColor?
	
	internal var switchOffTintColor: HexColor?
	
	internal var switchThumbTintColor: HexColor?
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case textStyle 				= "text_style"
		case switchOnTintColor		= "switch_on_tint_color"
		case switchOffTintColor		= "switch_off_tint_color"
		case switchThumbTintColor	= "switch_thumb_tint_color"
	}
}
