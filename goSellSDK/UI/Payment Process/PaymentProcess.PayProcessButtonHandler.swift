//
//  PaymentProcess.PayProcessButtonHandler.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal extension PaymentProcess {
	
	internal final class PayProcessButtonHandler: PayButtonHandler, ProcessHandlerInterface {
		
		// MARK: - Internal -
		// MARK: Properties
		
		internal override var canButtonBeHighlighted: Bool {
			
			return !self.process.dataManager.isExecutingAPICalls
		}
		
		// MARK: Methods
		
		internal required init(process: PaymentProcess) {
			
			self.process = process
			super.init()
		}
		
		internal convenience init(process: PaymentProcess, button: TapButton?) {
			
			self.init(process: process)
			self.setButton(button)
		}
		
		internal override func updateButtonState() {
			
			self.updateAmount()
			
			guard let selectedPaymentViewModel = self.process.viewModelsHandler.selectedPaymentOptionCellViewModel else {
				
				self.makeButtonEnabled(false)
				return
			}
			
			let payButtonEnabled = selectedPaymentViewModel.affectsPayButtonState && selectedPaymentViewModel.isReadyForPayment
			self.makeButtonEnabled(payButtonEnabled)
		}
		
		internal override func buttonClicked() {
			
			super.buttonClicked()
			
			guard let selectedPaymentViewModel = self.process.viewModelsHandler.selectedPaymentOptionCellViewModel, selectedPaymentViewModel.isReadyForPayment, !self.process.dataManager.isExecutingAPICalls else { return }
			
			self.process.startPayment(with: selectedPaymentViewModel)
		}
		
		// MARK: - Private -
		// MARK: Properties
		
		private unowned let process: PaymentProcess
		
		// MARK: Methods
		
		private func updateAmount() {
			
			let amountedCurrency = self.process.dataManager.selectedCurrency
			
			if let paymentOption = self.process.viewModelsHandler.selectedPaymentOptionCellViewModel?.paymentOption {
				
				let extraFeeAmount = AmountCalculator.extraFeeAmount(from: paymentOption.extraFees, in: amountedCurrency)
				
				let amount = AmountedCurrency(amountedCurrency.currency,
											  amountedCurrency.amount + extraFeeAmount,
											  amountedCurrency.currencySymbol)
				
				self.amount = amount
			}
			else {
				
				self.amount = amountedCurrency
			}
		}
	}
}
