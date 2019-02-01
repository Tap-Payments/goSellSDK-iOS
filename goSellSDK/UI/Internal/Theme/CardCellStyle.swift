//
//  CardCellStyle.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	UIKit.UIImage.UIImage

internal struct CardCellStyle: Decodable {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal var scanIconFrame: ResourceImage
	
	internal var scanIconIcon: ResourceImage
	
	internal var scanIcon: UIImage?
	
	internal var textInput: TextInputStyle
	
	internal var saveCard: SaveCardStyle
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case scanIconFrame 	= "scan_icon_frame"
		case scanIconIcon	= "scan_icon_icon"
		case textInput		= "input_styles"
		case saveCard		= "save_card"
	}
}
