//
//  Theme.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal struct Theme: Decodable {
    
	// MARK: - Internal -
	// MARK: Properties
	
	internal static var current: Theme {
		
		get {
		
			return ThemeManager.shared.currentTheme
		}
		set {
			
			ThemeManager.shared.currentTheme = newValue
		}
	}
	
	internal let name: String
	
	internal let isDefault: Bool
	
	internal var buttonStyles: [TapButtonStyle]
	
	internal var merchantHeaderStyle: NavigationBarStyle
	
	internal var paymentOptionsCellStyle: PaymentOptionCellsStyle
	
	internal let navigationBarStyle: NavigationBarStyle
	
	internal let searchBarStyle: SearchBarStyle
	
	internal let caseSelectionCellStyle: CaseSelectionCellStyle
	
	internal let otpScreenStyle: OTPScreenStyle
	
	internal let statusPopupStyle: StatusPopupStyle
	
	internal let commonStyle: CommonStyle
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case name						= "name"
		case isDefault					= "default"
		case buttonStyles				= "tap_buttons"
		case merchantHeaderStyle		= "merchant_header"
		case paymentOptionsCellStyle	= "payment_option_cells"
		case navigationBarStyle			= "navigation_bar"
		case searchBarStyle				= "search_bar"
		case caseSelectionCellStyle		= "case_selection_cell"
		case otpScreenStyle				= "otp_screen"
		case statusPopupStyle			= "status_popup"
		case commonStyle				= "common"
	}
}
