//
//  CommonStyle.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import enum TapVisualEffectView.TapBlurEffectStyle

internal struct CommonStyle: Decodable {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal let loaderAnimationDuration: TimeInterval
	internal let keyboardAppearance: KeyboardAppearance
	internal let blurStyle: TapBlurEffectStyle
	internal let icons: CommonImages
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case loaderAnimationDuration 	= "loader_animation_duration"
		case keyboardAppearance			= "keyboard_appearance"
		case blurStyle					= "blur_style"
		case icons						= "icons"
	}
}
