//
//  SavedCardStyle.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
internal struct SavedCardStyle: Decodable {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal let cardNumber: TextStyle
	
	internal let checkmarkIcon: ResourceImage
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case cardNumber 	= "number_style"
		case checkmarkIcon	= "checkmark_icon"
	}
}
