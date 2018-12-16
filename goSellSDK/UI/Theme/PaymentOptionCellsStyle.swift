//
//  PaymentOptionCellsStyle.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal struct PaymentOptionCellsStyle: Decodable {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal let currency: CurrencySelectionCellStyle
	
	internal let group: GroupCellStyle
	
	internal let groupWithButton: GroupWithButtonCellStyle
	
	internal let web: WebCellStyle
	
	internal let card: CardCellStyle
	
	internal let savedCard: SavedCardStyle
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case currency			= "currency"
		case group 				= "group"
		case groupWithButton	= "group_button"
		case web				= "web"
		case card				= "card"
		case savedCard			= "saved_card"
	}
}
