//
//  CardCellStyle.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal struct CardCellStyle: Decodable {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal let scanIcon: ResourceImage
	
	internal let textInput: TextInputStyle
	
	internal let saveCard: SaveCardStyle
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case scanIcon 	= "scan_icon"
		case textInput	= "input_styles"
		case saveCard	= "save_card"
	}
}
