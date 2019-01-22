//
//  PaymentProcess.Validation.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal extension PaymentProcess {
	
	internal final class Validation {
		
		// MARK: - Internal -
		// MARK: Methods
		
		internal static func canStart(using session: SessionProtocol) -> Bool {
			
			if PaymentProcess.shared.dataManager.isLoadingPaymentOptions { return false }
			
			guard let dataSource = session.dataSource, let customer = dataSource.customer, self.isCustomerValid(customer) else { return false }
			
			let mode = dataSource.mode ?? .default
			if mode == .cardSaving { return true }
			
			if dataSource.currency == nil { return false }
			return (AmountCalculator.totalAmount(for: session) ?? .zero).decimalValue > 0.0
		}
		
		internal static func isCustomerValid(_ customer: Customer) -> Bool {
			
			customer.validateFields()
			
			if customer.identifier != nil { return true }
			if customer.firstName == nil { return false }
			
			return customer.emailAddress != nil || customer.phoneNumber != nil
		}
		
		// MARK: - Private -
		// MARK: Methods
		
		@available(*, unavailable) private init() {
			
			fatalError("This class cannot be instantiated.")
		}
	}
}
