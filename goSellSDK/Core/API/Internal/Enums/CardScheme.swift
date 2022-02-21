//
//  CardScheme.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import enum TapCardVlidatorKit_iOS.CardBrand

internal struct CardScheme {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal let cardBrand: CardBrand
    
    // MARK: - Private -
    // MARK: Methods
    
    private init(_ brand: CardBrand) {
        
        self.cardBrand = brand
    }
}

// MARK: - Decodable
extension CardScheme: Decodable {
    
    internal init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        let brand = try container.decode(CardBrand.self)
        
        self.init(brand)
    }
}

// MARK: - Equatable
extension CardScheme: Equatable {
    
    internal static func == (lhs: CardScheme, rhs: CardScheme) -> Bool {
    
        return lhs.cardBrand == rhs.cardBrand
    }
}
