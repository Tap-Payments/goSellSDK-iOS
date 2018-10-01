//
//  MerchantHeaderStyle.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal struct MerchantHeaderStyle: Decodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal let placeholderLogo: ResourceImage
    internal let logoLoaderColor: HexColor
	internal let titleStyle: TextStyle
    internal let backgroundColor: HexColor
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case placeholderLogo 	= "logo_placeholder"
		case logoLoaderColor 	= "logo_loader_color"
		case titleStyle			= "title_style"
		case backgroundColor	= "background_color"
	}
}
