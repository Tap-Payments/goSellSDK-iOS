//
//  TapButtonStateStyle.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	UIKit.UIColor.UIColor
import class 	UIKit.UIFont.UIFont
import class 	UIKit.UIImage.UIImage

internal struct TapButtonStateStyle: Decodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal let backgroundColor: HexColor
    
    internal let loaderColor: HexColor
	
	internal let securityIcon: ResourceImage?
	
	internal let titleStyle: TextStyle
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case backgroundColor	= "background_color"
		case loaderColor 		= "loader_color"
		case securityIcon		= "security_icon"
		case titleStyle 		= "title_style"
	}
}
