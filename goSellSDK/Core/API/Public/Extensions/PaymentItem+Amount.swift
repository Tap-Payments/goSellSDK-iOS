//
//  PaymentItem+Amount.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

public extension PaymentItem {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Plain amount.
    @objc var plainAmount: Decimal {
        
        return self.amountPerUnit * self.quantity.value
    }
    
    /// Discount amount.
    @objc var discountAmount: Decimal {
        
        guard let nonnullDiscount = self.discount else { return 0.0 }
        
        switch nonnullDiscount.type {
            
        case .percents: return self.plainAmount * nonnullDiscount.normalizedValue
        case .fixedAmount:  return nonnullDiscount.value

        }
    }
    
    /// Taxes amount.
    @objc var taxesAmount: Decimal {
        
        return Process.NonGenericAmountCalculator.taxes(on: self.plainAmount - self.discountAmount, with: self.taxes ?? [])
    }
    
    /// Total item amount.
    @objc var totalItemAmount: Decimal {
        
        return Process.NonGenericAmountCalculator.totalAmount(of: self)
    }
}
