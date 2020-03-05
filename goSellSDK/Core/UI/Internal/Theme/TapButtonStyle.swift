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
	
    internal var enabled: TapButtonStateStyle
	
    internal var disabled: TapButtonStateStyle
	
    internal var highlighted: TapButtonStateStyle
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case type 			= "type"
		case enabled 		= "enabled"
		case disabled 		= "disabled"
		case highlighted	= "highlighted"
	}
}

internal extension TapButtonStyle {
	
	enum ButtonType: String, Decodable {
		
		case pay 		= "pay"
		case confirmOTP	= "confirm_otp"
		case save		= "save"
        case async      = "close_async"
	}
}
