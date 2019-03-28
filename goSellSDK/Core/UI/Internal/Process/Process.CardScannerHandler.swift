//
//  Process.CardScannerHandler.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//


internal protocol CardScannerHandlerInterface {
	
	func prepareCardScannerController(_ cardScannerController: CardScannerViewController)
}

internal extension Process {
	
	final class CardScannerHandler: CardScannerHandlerInterface, CardScannerViewControllerDelegate {
		
		// MARK: - Internal -
		// MARK: Properties
		
		internal unowned let process: ProcessInterface
		
		// MARK: Methods
		
		internal init(process: ProcessInterface) {
			
			self.process = process
		}
		
		internal func prepareCardScannerController(_ cardScannerController: CardScannerViewController) {
			
			cardScannerController.delegate = self
		}
		
		internal func cardScannerController(_ scannerController:	CardScannerViewController,
											didScan	cardNumber:		String?,
											expirationDate:			ExpirationDate?,
											cvv:					String?,
											cardholderName:			String?) {
			
			self.process.viewModelsHandlerInterface.cardPaymentOptionsCellModel.update(withScanned:		cardNumber,
																					   expirationDate:	expirationDate,
																					   cvv:				cvv,
																					   cardholderName:	cardholderName)
		}
	}
}
