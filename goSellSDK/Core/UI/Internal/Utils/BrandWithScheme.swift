//
//  BrandWithScheme.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import enum TapCardVlidatorKit_iOS.CardBrand
import enum TapCardVlidatorKit_iOS.CardValidationState

internal struct BrandWithScheme {
    
    // MARK: - Internal -
    // MARK: Properties
    
    let brand: CardBrand
    let scheme: CardScheme?
    let validationState: CardValidationState
}

extension BrandWithScheme: Equatable {
    
    internal static func == (lhs: BrandWithScheme, rhs: BrandWithScheme) -> Bool {
    
        return lhs.validationState == rhs.validationState && lhs.brand == rhs.brand && lhs.scheme == rhs.scheme
    }
}
