//
//  AmountCalculator.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal class AmountCalculator {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal static func totalAmount(of item: PaymentItem) -> Decimal {
        
        let result = item.plainAmount - item.discountAmount + item.taxesAmount
        return result
    }
    
    internal static func totalAmount(of items: [PaymentItem], with taxes: [Tax]?, and shipping: [Shipping]?) -> Decimal {
        
        let itemsPlainAmount = items.reduce(0.0, { $0 + $1.plainAmount })
        let itemsDiscountAmount = items.reduce(0.0, { $0 + $1.discountAmount })
        let discountedAmount = itemsPlainAmount - itemsDiscountAmount
        
        let shippingAmount = (shipping ?? []).reduce(0.0, { $0 + $1.amount })
        
        let itemsTaxesAmount = items.reduce(0.0, { $0 + $1.taxesAmount })
        let taxesAmount = self.taxes(on: discountedAmount + shippingAmount, with: taxes ?? [])
        let totalTaxesAmount = itemsTaxesAmount + taxesAmount
        
        let result = discountedAmount + shippingAmount + totalTaxesAmount
        
        return result
    }
    
    internal static func taxes(on amount: Decimal, with taxes: [Tax]) -> Decimal {
        
        var result: Decimal = 0.0
        
        taxes.forEach { tax in
            
            switch tax.amount.type {
                
            case .percents: result += amount * tax.amount.normalizedValue
            case .fixedAmount:  result += tax.amount.value

            }
        }
        
        return result
    }
    
    // MARK: - Private -
    
    @available(*, unavailable) private init() { fatalError("AmountCalculator cannot be instantiated.") }
}
