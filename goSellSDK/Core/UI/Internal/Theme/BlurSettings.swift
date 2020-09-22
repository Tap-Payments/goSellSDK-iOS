//
//  BlurSettings.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import enum		TapVisualEffectViewV2.TapBlurEffectStyle

internal struct BlurSettings: Decodable {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal var style: TapBlurEffectStyle
	
	internal var progress: CGFloat
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case style		= "style"
		case progress	= "progress"
	}
}
