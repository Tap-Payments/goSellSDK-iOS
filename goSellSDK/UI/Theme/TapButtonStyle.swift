//
//  TapButtonStyle.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Tap Button Style.
internal struct TapButtonStyle: Decodable {
	
    // MARK: - Internal -
    // MARK: Properties
	
	internal let type: ButtonType
	
    internal let enabled: TapButtonStateStyle
	
    internal let disabled: TapButtonStateStyle
	
    internal let highlighted: TapButtonStateStyle
	
	internal init(type: ButtonType, enabled: TapButtonStateStyle, disabled: TapButtonStateStyle, highlighted: TapButtonStateStyle) {
		
		self.type = type
		self.enabled = enabled
		self.disabled = disabled
		self.highlighted = highlighted
	}
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case type 			= "type"
		case enabled 		= "enabled"
		case disabled 		= "disabled"
		case highlighted	= "highlighted"
	}
}

internal extension TapButtonStyle {
	
	internal enum ButtonType: String, Decodable {
		
		case pay 		= "pay"
		case confirmOTP	= "confirm_otp"
		case save		= "save"
		case draewilSave = "draewil_save"
	}
}
