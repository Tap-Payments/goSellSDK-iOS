//
//  PaymentItem+Amount.swift
//  goSellSDK
//
//  Created by Dennis Pashkov on 5/26/18.
//

public extension PaymentItem {
    
    // MARK: - Public -
    // MARK: Properties
    
    public var plainAmount: Decimal {
        
        return self.amountPerUnit * self.quantity.value
    }
    
    public var discountAmount: Decimal {
        
        guard let nonnullDiscount = self.discount else { return 0.0 }
        
        switch nonnullDiscount.type {
            
        case .percentBased: return self.plainAmount * nonnullDiscount.normalizedValue
        case .fixedAmount:  return nonnullDiscount.value

        }
    }
    
    public var taxesAmount: Decimal {
        
        guard let nonnullTaxes = self.taxes?.map({ $0.amount }), nonnullTaxes.count > 0 else { return 0.0 }
        
        let amountToCalculateTaxesOn = self.plainAmount - self.discountAmount
        
        var result: Decimal = 0.0
        nonnullTaxes.forEach { tax in
            
            switch tax.type {
                
            case .percentBased: result += amountToCalculateTaxesOn * tax.normalizedValue
            case .fixedAmount:  result += tax.value

            }
        }
        
        return result
    }
    
    public var totalItemAmount: Decimal {
        
        return self.plainAmount - self.discountAmount + self.taxesAmount
    }
}
