//
//  PaymentProcess.Validation.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal extension Process {
	
	final class Validation {
		
		// MARK: - Internal -
		// MARK: Methods
		
		internal static func canStart(using session: SessionProtocol) -> Bool {
			
			if Process.hasAliveInstance && Process.shared.dataManagerInterface.isLoadingPaymentOptions { return false }
			
			guard let dataSource = session.dataSource else { return false }
			let mode = dataSource.mode ?? .default
			
			let amount = AmountCalculator<PaymentClass>.totalAmount(for: session) ?? .zero
			
			if mode == .cardTokenization {
				
				return dataSource.currency != nil && amount.decimalValue > 0.0
			}
            
            /*if dataSource.isApplePay ?? false
            {
                guard let _ = dataSource.appleTokenData, let _ = dataSource.applePayMerchantID else { return false }
            }*/
			
			guard let customer = dataSource.customer, self.isCustomerValid(customer) else { return false }
			
			if mode == .cardSaving { return true }
			
			return dataSource.currency != nil && amount.decimalValue > 0.0
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
