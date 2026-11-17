//
//  ListCardsResponse.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
/// Response object for List All Cards API.
internal struct ListCardsResponse: Decodable {
	
	// MARK: - Internal -
	// MARK: Properties
	
	/// Object type.
	internal let object: String
	
	/// Defines if there are more cards to load.
	internal let hasMore: Bool
	
	/// Cards.
	internal let cards: [SavedCard]
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case object		= "object"
		case hasMore	= "has_more"
		case cards		= "data"
	}
}
