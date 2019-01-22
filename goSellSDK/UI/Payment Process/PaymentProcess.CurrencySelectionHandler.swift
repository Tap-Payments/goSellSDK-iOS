//
//  PaymentProcess.CurrencySelectionHandler.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal extension PaymentProcess {
	
	internal class CurrencySelectionHandler: ProcessHandlerInterface {
		
		// MARK: - Internal -
		// MARK: Methods
		
		internal required init(process: PaymentProcess) {
			
			self.process = process
		}
		
		internal func prepareCurrencySelectionController(_ controller: CurrencySelectionViewController) {
			
			controller.delegate = self
			
			let supportedCurrencies = self.process.dataManager.supportedCurrencies
			controller.setCurrencies(supportedCurrencies, preselectedCurrency: self.process.viewModelsHandler.currencyCellViewModel.userSelectedCurrency)
		}
		
		// MARK: - Private -
		// MARK: Properties
		
		private unowned let process: PaymentProcess
	}
}

// MARK: - CurrencySelectionViewControllerDelegate
extension PaymentProcess.CurrencySelectionHandler: CurrencySelectionViewControllerDelegate {
	
	internal func currencySelectionViewControllerDidFinish(with currency: AmountedCurrency, changed: Bool) {
		
		self.process.viewModelsHandler.currencyCellViewModel.userSelectedCurrency = currency
		self.process.dataManager.userSelectedCurrency = currency
	}
}
