//
//  Merchant.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Merchant model.
internal struct Merchant: Decodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Merchant name
    internal let name: String
    
    /// Merchant logo URL
    internal let logoURL: URL
    
    /// List of currencies supported by merchant.
    internal let supportedCurrencies: [Currency]
    
    /// Default currency of the merchant.
    internal let defaultCurrency: Currency
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {

        case name = "name"
        case logoURL = "logo"
        case supportedCurrencies = "supported_currencies"
        case defaultCurrency = "currency_code"
    }
}
