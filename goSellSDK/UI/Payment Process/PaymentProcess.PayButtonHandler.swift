//
//  PaymentProcess.PayButtonHandler.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal extension PaymentProcess {
	
	internal class PayButtonHandler: TapButtonHandler {
		
		// MARK: - Internal -
		// MARK: Properties
		
		internal override var canButtonBeHighlighted: Bool {
			
			return !PaymentProcess.shared.dataManager.isExecutingAPICalls
		}
		
		internal var amount: AmountedCurrency? {
			
			didSet {
				
				self.updateAmountOnTheButton()
			}
		}
		
		// MARK: Methods
		
		internal override func updateButtonState() {
			
			super.updateButtonState()
			self.updateAmountOnTheButton()
		}
		
		// MARK: - Private -
		// MARK: Methods
		
		private func updateAmountOnTheButton() {
			
			guard let displayedAmount = self.amount, displayedAmount.amount > 0.0 else {
				
				self.button?.setLocalizedText(.btn_pay_title_generic)
				self.button?.forceDisabled = true
				
				return
			}
			
			let amountString = CurrencyFormatter.shared.format(displayedAmount)
			self.button?.setLocalizedText(.btn_pay_title_amount, amountString)
			
			self.button?.forceDisabled = false
		}
	}
}
