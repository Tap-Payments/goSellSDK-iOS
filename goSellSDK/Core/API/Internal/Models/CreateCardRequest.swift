//
//  CreateCardRequest.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
/// Request body for Create Card API.
internal struct CreateCardRequest: Encodable {
	
	// MARK: - Internal -
	// MARK: Properties
	
	/// Card source identifier (token identifier).
	internal let source: String
	
	// MARK: Methods
	
	/// Initializes create card request from the source of the card.
	///
	/// - Parameter source: Card source identifier.
	internal init(_ source: Source) {
		
		self.source = source.identifier
	}
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case source	= "source"
	}
}
