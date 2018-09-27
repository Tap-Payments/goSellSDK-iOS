//
//  NSTextAlignment+Additions.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import enum		UIKit.NSText.NSTextAlignment

internal extension NSTextAlignment {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal var localizedTextAlignment: LocalizedTextAlignment {
		
		switch self {
			
		case .left: 		return .left
		case .center: 		return .center
		case .right: 		return .right
		case .natural: 		return .natural
		case .justified:	return .justified
		}
	}
}
