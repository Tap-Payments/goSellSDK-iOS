//
//  AppearanceStyle.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal struct AppearanceStyle<Style>: Decodable where Style: Decodable {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal let windowed: Style
	
	internal let fullscreen: Style
	
	internal subscript(appearance: AppearanceMode) -> Style {
		
		switch appearance {
			
		case .fullscreen:	return self.fullscreen
		case .windowed:		return self.windowed
			
		}
	}
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case windowed	= "windowed"
		case fullscreen	= "fullscreen"
	}
}
