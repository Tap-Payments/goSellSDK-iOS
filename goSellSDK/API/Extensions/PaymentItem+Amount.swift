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
    public var plainAmount: Decimal {
        
        return self.amountPerUnit * self.quantity.value
    }
    
    /// Discount amount.
    public var discountAmount: Decimal {
        
        guard let nonnullDiscount = self.discount else { return 0.0 }
        
        switch nonnullDiscount.type {
            
        case .percents: return self.plainAmount * nonnullDiscount.normalizedValue
        case .fixedAmount:  return nonnullDiscount.value

        }
    }
    
    /// Taxes amount.
    public var taxesAmount: Decimal {
        
        return PaymentProcess.AmountCalculator.taxes(on: self.plainAmount - self.discountAmount, with: self.taxes ?? [])
    }
    
    /// Total item amount.
    public var totalItemAmount: Decimal {
        
        return PaymentProcess.AmountCalculator.totalAmount(of: self)
    }
}
