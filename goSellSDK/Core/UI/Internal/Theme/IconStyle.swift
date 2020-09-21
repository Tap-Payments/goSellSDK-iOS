//
//  IconStyle.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics

internal struct IconStyle: Decodable {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal let placeholder: ResourceImage?
	
	internal let cornerRadius: CGFloat
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case placeholder	= "placeholder"
		case cornerRadius	= "corner_radius"
	}
}
