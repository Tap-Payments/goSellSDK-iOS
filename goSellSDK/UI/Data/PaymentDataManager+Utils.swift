//
//  PaymentDataManager+Utils.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import enum TapCardValidator.CardBrand

internal extension PaymentDataManager {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal func iconURL(for cardBrand: CardBrand) -> URL? {
        
        let possibleOptions = self.paymentOptions.filter { $0.supportedCardBrands.contains(cardBrand) }
        if let original = possibleOptions.first(where: { $0.brand == cardBrand }) {
            
            return original.imageURL
        }
        else {
            
            return possibleOptions.first?.imageURL
        }
    }
}
