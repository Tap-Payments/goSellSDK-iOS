//
//  StatusPopupStyle.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal struct StatusPopupStyle: Decodable {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal let titleStyle: TextStyle
	
	internal let subtitleStyle: TextStyle
	
	internal let successImage: ResourceImage
	
	internal let failureImage: ResourceImage
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case titleStyle		= "title_style"
		case subtitleStyle	= "subtitle_style"
		case successImage	= "success_icon"
		case failureImage	= "failure_icon"
	}
}
