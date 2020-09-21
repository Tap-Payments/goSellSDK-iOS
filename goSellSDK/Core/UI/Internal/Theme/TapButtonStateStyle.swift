//
//  TapButtonStateStyle.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import class	UIKit.UIColor.UIColor
import class 	UIKit.UIFont.UIFont
import class 	UIKit.UIImage.UIImage

internal struct TapButtonStateStyle: Decodable {
    
    // MARK: - Internal -
    // MARK: Properties
	
	internal var backgroundColor: HexColor
    
    internal let loaderColor: HexColor
	
	internal let securityIcon: ResourceImage
	
	internal var titleStyle: TextStyle
	
	internal var isLoaderVisible: Bool
	
	internal var isSecurityIconVisible: Bool
	
	internal var cornerRadius: CGFloat
	
	internal var insets: TapEdgeInsets
	
	internal var height: CGFloat
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case backgroundColor		= "background_color"
		case loaderColor 			= "loader_color"
		case securityIcon			= "security_icon"
		case titleStyle 			= "title_style"
		case isLoaderVisible		= "loader_visible"
		case isSecurityIconVisible	= "security_icon_visible"
		case cornerRadius			= "corner_radius"
		case insets					= "insets"
		case height					= "height"
	}
}
