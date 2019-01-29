//
//  CommonStyle.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import enum TapVisualEffectView.TapBlurEffectStyle

internal struct CommonStyle: Decodable {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal let loaderAnimationDuration: TimeInterval
	internal let keyboardAppearance: KeyboardAppearance
	internal let statusBar: AppearanceStyle<StatusBarStyle>
	internal let blurStyle: AppearanceStyle<TapBlurEffectStyle>
	internal let backgroundColor: AppearanceStyle<HexColor>
	internal let icons: CommonImages
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case loaderAnimationDuration 	= "loader_animation_duration"
		case keyboardAppearance			= "keyboard_appearance"
		case statusBar					= "status_bar"
		case blurStyle					= "blur_style"
		case backgroundColor			= "background_color"
		case icons						= "icons"
	}
}
