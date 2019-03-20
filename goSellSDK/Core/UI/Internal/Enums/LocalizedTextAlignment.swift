//
//  LocalizedTextAlignment.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import enum UIKit.NSText.NSTextAlignment

internal enum LocalizedTextAlignment: String, Decodable {
	
	case left 		= "left"
	case center 	= "center"
	case right 		= "right"
	case leading 	= "leading"
	case trailing 	= "trailing"
	case natural 	= "natural"
	case justified	= "justified"
	
	// MARK: Properties
	
	internal var textAlignment: NSTextAlignment {
		
		switch self {
			
		case .left: 		return .left
		case .center:		return .center
		case .right: 		return .right
		case .leading: 		return LocalizationManager.shared.layoutDirection == .leftToRight ? .left 	: .right
		case .trailing:		return LocalizationManager.shared.layoutDirection == .leftToRight ? .right	: .left
		case .natural: 		return .natural
		case .justified:	return .justified

		}
	}
}
