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
        
        if let option = self.paymentOptions.first(where: { $0.supportedCardBrands.contains(cardBrand) }) {
            
            return option.imageURL
        }
        
        return nil
    }
}
