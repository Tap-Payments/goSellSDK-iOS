//
//  LocalizedTextAlignment.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import enum UIKit.NSText.NSTextAlignment

internal enum LocalizedTextAlignment {
	
	case left
	case center
	case right
	case leading
	case trailing
	case natural
	case justified
	
	// MARK: Properties
	
	internal var textAlignment: NSTextAlignment {
		
		switch self {
			
		case .left: 		return .left
		case .center:		return .center
		case .right: 		return .right
		case .leading: 		return LocalizationProvider.shared.layoutDirection == .leftToRight ? .left 	: .right
		case .trailing:		return LocalizationProvider.shared.layoutDirection == .leftToRight ? .right	: .left
		case .natural: 		return .natural
		case .justified:	return .justified

		}
	}
}
