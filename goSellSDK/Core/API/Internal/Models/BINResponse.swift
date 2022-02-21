//
//  BINResponse.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import TapCardVlidatorKit_iOS

/// BIN Response model.
internal struct BINResponse {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Defines if address is required
    internal let isAddressRequired: Bool
    
    /// Card issuer bank.
    internal let bank: String?
    
    /// Bank logo URL.
    internal let bankLogoURL: URL?
    
    /// Card BIN number.
    internal let binNumber: String
    
    /// Card brand.
    internal let cardBrand: CardBrand
    
    /// Card scheme.
    internal let scheme: CardScheme?
    
    /// Card issuing country.
    internal let country: Country?
    
    /// Card Type.
    internal let cardType: CardType
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case isAddressRequired  = "address_required"
        case bank               = "bank"
        case bankLogoURL        = "bank_logo"
        case binNumber          = "bin"
        case cardBrand          = "card_brand"
        case scheme             = "card_scheme"
        case country            = "country"
        case cardType           = "card_type"
    }
}

// MARK: - Equatable
extension BINResponse: Equatable {
    
    internal static func == (lhs: BINResponse, rhs: BINResponse) -> Bool {
        
        return lhs.binNumber == rhs.binNumber
    }
}

// MARK: - Decodable
extension BINResponse: Decodable {
    
    internal init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let isAddressRequired   = try container.decodeIfPresent(Bool.self, forKey: .isAddressRequired) ?? false
        let bank                = try container.decodeIfPresent(String.self, forKey: .bank)
        let bankLogoURL         = container.decodeURLIfPresent(for: .bankLogoURL)
        let binNumber           = try container.decode(String.self, forKey: .binNumber)
        let cardBrand           = try container.decodeIfPresent(CardBrand.self, forKey: .cardBrand) ?? .unknown
        let cardType            = CardType(cardTypeString:try container.decodeIfPresent(String.self, forKey: .cardType) ?? "")
        let scheme              = try container.decodeIfPresent(CardScheme.self, forKey: .scheme)
        
        var country: Country? = nil
        if let countryString = try container.decodeIfPresent(String.self, forKey: .country), !countryString.isEmpty {
            
            country = try container.decodeIfPresent(Country.self, forKey: .country)
        }
        
        self.init(isAddressRequired: isAddressRequired, bank: bank, bankLogoURL: bankLogoURL, binNumber: binNumber, cardBrand: cardBrand, scheme: scheme, country: country, cardType: cardType)
    }
}
