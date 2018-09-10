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
    
    internal func iconURL(for cardBrand: CardBrand, scheme: CardScheme?) -> URL? {
        
        let brand = self.appliedCardBrand(from: cardBrand, scheme: scheme)
        
        let possibleOptions = self.paymentOptions.filter { $0.brand == brand || $0.supportedCardBrands.contains(brand) }
        if let original = possibleOptions.first(where: { $0.brand == brand }) {
            
            return original.imageURL
        }
        else {
            
            return possibleOptions.first?.imageURL
        }
    }
    
    // MARK: - Private -
    // MARK: Methods
    
    private func appliedCardBrand(from brand: CardBrand, scheme: CardScheme?) -> CardBrand {
        
        if let schemeBrand = scheme?.cardBrand {
            
            let currency = self.selectedCurrency.currency
            let filterClosure: (PaymentOption) -> Bool = { $0.brand == schemeBrand && $0.supportedCurrencies.contains(currency) }
            
            if self.paymentOptions.first(where: filterClosure) != nil {
                
                return schemeBrand
            }
        }
        
        return brand
    }
}
