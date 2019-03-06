//
//  Merchant.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Merchant model.
internal struct Merchant: Decodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Merchant name
    internal let name: String
    
    /// Merchant logo URL
    internal let logoURL: URL
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {

        case name       = "name"
        case logoURL    = "logo"
    }
}
