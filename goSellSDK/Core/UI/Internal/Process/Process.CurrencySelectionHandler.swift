//
//  PaymentProcess.CurrencySelectionHandler.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal protocol CurrencySelectionHandlerInterface {
	
	func prepareCurrencySelectionController(_ controller: CurrencySelectionViewController)
}

internal extension Process {
	
	class CurrencySelectionHandler: CurrencySelectionHandlerInterface {
	
		// MARK: - Internal -
		// MARK: Properties
		
		internal unowned let process: ProcessInterface
		
		// MARK: Methods
		
		internal required init(process: ProcessInterface) {
			
			self.process = process
		}
		
		internal func prepareCurrencySelectionController(_ controller: CurrencySelectionViewController) {
			
			fatalError("Should be implemented in extensions.")
		}
	}
	
	final class PaymentCurrencySelectionHandler: CurrencySelectionHandler, CurrencySelectionViewControllerDelegate {
	
		internal override func prepareCurrencySelectionController(_ controller: CurrencySelectionViewController) {
			
			controller.delegate = self
			
			let supportedCurrencies = self.process.dataManagerInterface.supportedCurrencies
			controller.setCurrencies(supportedCurrencies, preselectedCurrency: self.process.viewModelsHandlerInterface.currencyCellViewModel.userSelectedCurrency)
		}
		
		internal func currencySelectionViewControllerDidFinish(with currency: AmountedCurrency, changed: Bool) {
			
			self.process.viewModelsHandlerInterface.currencyCellViewModel.userSelectedCurrency = currency
			self.process.dataManagerInterface.userSelectedCurrency = currency
		}
	}
}
