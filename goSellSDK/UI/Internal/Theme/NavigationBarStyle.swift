//
//  NavigationBarStyle.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal struct NavigationBarStyle: Decodable {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal var backgroundColor: HexColor
	
	internal let backIcon: ResourceImage
	
	internal var titleStyle: TextStyle
	
	internal var cancelNormalStyle: TextStyle
	
	internal var cancelHighlightedStyle: TextStyle
	
	internal let iconStyle: IconStyle?
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case backgroundColor		= "background_color"
		case backIcon 				= "back_icon"
		case titleStyle				= "title_style"
		case cancelNormalStyle		= "cancel_normal_style"
		case cancelHighlightedStyle	= "cancel_highlighted_style"
		case iconStyle				= "icon_style"
	}
}
