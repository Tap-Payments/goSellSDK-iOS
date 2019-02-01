//
//  PaymentOptionCellsStyle.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal struct PaymentOptionCellsStyle: Decodable {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal let currency: CurrencySelectionCellStyle
	
	internal let group: GroupCellStyle
	
	internal let groupWithButton: GroupWithButtonCellStyle
	
	internal let web: WebCellStyle
	
	internal var card: CardCellStyle
	
	internal let savedCard: SavedCardStyle
	
	internal let glowStyle: GlowStyle
	
	internal let alwaysGlowStyle: GlowStyle
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case currency			= "currency"
		case group 				= "group"
		case groupWithButton	= "group_button"
		case web				= "web"
		case card				= "card"
		case savedCard			= "saved_card"
		case glowStyle			= "glow_style"
		case alwaysGlowStyle	= "always_glow_style"
	}
}
