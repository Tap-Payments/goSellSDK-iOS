//
//  NavigationBarStyle.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal struct NavigationBarStyle: Decodable {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal let backIcon: ResourceImage
	
	internal let titleStyle: TextStyle
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case backIcon 	= "back_icon"
		case titleStyle	= "title_style"
	}
}
