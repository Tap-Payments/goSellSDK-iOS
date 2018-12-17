//
//  GlowStyle.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal struct GlowStyle: Decodable {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal let color: HexColor
	internal let radius: CGFloat
	internal let animationDuration: TimeInterval
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case color				= "color"
		case radius				= "radius"
		case animationDuration	= "duration"
	}
}
