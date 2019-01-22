//
//  PaymentProcess.CardScannerHandler.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal extension PaymentProcess {
	
	internal class CardScannerHandler: ProcessHandlerInterface {
		
		// MARK: - Internal -
		// MARK: Methods
		
		internal required init(process: PaymentProcess) {
			
			self.process = process
		}
		
		internal func prepareCardScannerController(_ cardScannerController: CardScannerViewController) {
			
			cardScannerController.delegate = self
		}
		
		// MARK: - Private -
		// MARK: Properties
		
		private unowned let process: PaymentProcess
	}
}

// MARK: - CardScannerViewControllerDelegate
extension PaymentProcess.CardScannerHandler: CardScannerViewControllerDelegate {
	
	internal func cardScannerController(_ scannerController:	CardScannerViewController,
										didScan	cardNumber:		String?,
										expirationDate:			ExpirationDate?,
										cvv:					String?,
										cardholderName:			String?) {
		
		self.process.viewModelsHandler.cardPaymentOptionsCellModel.update(withScanned:		cardNumber,
																		  expirationDate:	expirationDate,
																		  cvv:				cvv,
																		  cardholderName:	cardholderName)
	}
}
