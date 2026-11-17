//
//  Merchant.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
/// Merchant model.
internal struct Merchant: Codable, OptionallyIdentifiableWithString {
	
    // MARK: - Internal -
    // MARK: Properties
	
	/// Merchant identifier.
	internal private(set) var identifier: String?
	
    /// Merchant name
    internal private(set) var name: String?
    
    /// Merchant logo URL
    internal private(set) var logoURL: URL?
	
	// MARK: Methods
	
	/// Initializes merchant with the identifier.
	///
	/// - Parameter identifier: Merchant identifier.
	internal init(identifier: String) {
		
		self.identifier	= identifier
	}
	
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {

		case identifier	= "id"
        case name       = "name"
        case logoURL    = "logo"
    }
}
