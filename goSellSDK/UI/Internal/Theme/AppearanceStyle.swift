//
//  AppearanceStyle.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal struct AppearanceStyle<Style>: Decodable where Style: Decodable {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal var windowed: Style
	
	internal var fullscreen: Style
	
	internal subscript(appearance: AppearanceMode) -> Style {
		
		get {
			
			switch appearance {
				
			case .fullscreen:	return self.fullscreen
			case .windowed:		return self.windowed
				
			}
		}
		set {
			
			switch appearance {
				
			case .fullscreen:	self.fullscreen	= newValue
			case .windowed:		self.windowed	= newValue

			}
		}
	}
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case windowed	= "windowed"
		case fullscreen	= "fullscreen"
	}
}
