//
//  PaymentProcess.AmountCalculator.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal extension PaymentProcess {
	
	internal final class AmountCalculator {
		
		// MARK: - Internal -
		// MARK: Methods
		
		internal static func totalAmount(for session: SessionProtocol) -> NSDecimalNumber? {
			
			guard let dataSource = session.dataSource else { return nil }
			let mode = dataSource.mode ?? .default
			
			if mode == .cardSaving { return nil }
			
			let items		= dataSource.items		?? nil
			let taxes		= dataSource.taxes		?? nil
			let shipping	= dataSource.shipping	?? nil
			
			let result = self.totalAmount(of: items, with: taxes, and: shipping, plainAmount: dataSource.amount)
			
			return NSDecimalNumber(decimal: result)
		}
		
		internal static func totalAmount(of item: PaymentItem) -> Decimal {
			
			let result = item.plainAmount - item.discountAmount + item.taxesAmount
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
		
		internal static func totalAmount(of paymentItems: [PaymentItem]?, with taxes: [Tax]?, and shipping: [Shipping]?, plainAmount: Decimal?) -> Decimal {
			
			let items = paymentItems ?? []
			
			let itemsPlainAmount = items.reduce(0.0, { $0 + $1.plainAmount })
			let itemsDiscountAmount = items.reduce(0.0, { $0 + $1.discountAmount })
			let discountedAmount = itemsPlainAmount - itemsDiscountAmount
			
			let shippingAmount = (shipping ?? []).reduce(0.0, { $0 + $1.amount })
			
			let itemsTaxesAmount = items.reduce(0.0, { $0 + $1.taxesAmount })
			let taxesAmount = self.taxes(on: discountedAmount + shippingAmount, with: taxes ?? [])
			let totalTaxesAmount = itemsTaxesAmount + taxesAmount
			
			var result = discountedAmount + shippingAmount + totalTaxesAmount
			
			if items.count == 0 {
				
				result += plainAmount ?? 0.0
			}
			
			return result
		}
		
		internal static func extraFeeAmount(from extraFees: [ExtraFee], in currency: AmountedCurrency) -> Decimal {
			
			var result: Decimal = 0.0
			
			extraFees.forEach { fee in
				
				switch fee.type {
					
				case .fixedAmount:
					
					if let feeAmountedCurrency = PaymentProcess.shared.dataManager.supportedCurrencies.first(where: { $0.currency == fee.currency }) {
						
						result += currency.amount * fee.value / feeAmountedCurrency.amount
					}
					else {
						
						fatalError("Currency \(fee.currency) is not a supported currency!")
					}
					
				case .percents:
					
					result += currency.amount * fee.normalizedValue
				}
			}
			
			return result
		}
		
		// MARK: - Private -
		// MARK: Methods
		
		@available(*, unavailable) private init() { fatalError("This class cannot be instantiated.") }
	}
}
