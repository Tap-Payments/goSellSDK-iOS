//
//  CardBrand+Additions.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import enum TapCardValidator.CardBrand

extension CardBrand: Decodable {
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        
        if let known = CardBrand(rawValue: stringValue) {
            
            self = known
        }
        else {
            
            self = .unknown
        }
    }
}
