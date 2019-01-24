//
//  PaymentProcess.WebPaymentHandler.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	TapAdditionsKit.TypeAlias

internal protocol WebPaymentHandlerInterface {
	
	var returnURL: URL { get }
	
	func prepareWebPaymentController(_ controller: WebPaymentViewController)
	func decision(forWebPayment url: URL) -> WebPaymentURLDecision
	func webPaymentProcessFinished(_ tapID: String)
}

internal extension Process {
	
	internal class WebPaymentHandler: WebPaymentHandlerInterface {
	
		// MARK: - Internal -
		// MARK: Properties
		
		internal unowned let process: ProcessInterface
		
		internal var returnURL: URL {
			
			return Constants.returnURL
		}
		
		// MARK: Methods
		
		required internal init(process: ProcessInterface) {
			
			self.process = process
		}
		
		internal func prepareWebPaymentController(_ controller: WebPaymentViewController) {
			
			guard let paymentOption = self.process.dataManagerInterface.currentPaymentOption else {
				
				fatalError("This code should never be executed.")
			}
			
			var binInformation: BINResponse? = nil
			if let binNumber = self.process.dataManagerInterface.currentPaymentCardBINNumber {
				
				binInformation = BINDataManager.shared.cachedBINData(for: binNumber)
			}
			
			controller.setup(with: paymentOption, url: self.process.dataManagerInterface.urlToLoadInWebPaymentController, binInformation: binInformation)
		}
		
		internal func decision(forWebPayment url: URL) -> WebPaymentURLDecision {
			
			let urlIsReturnURL = url.absoluteString.starts(with: Constants.returnURL.absoluteString)
			
			let shouldLoad = !urlIsReturnURL
			let redirectionFinished = urlIsReturnURL
			let tapID = url[Constants.tapIDKey]
			let shouldCloseWebPaymentScreen = redirectionFinished && self.process.dataManagerInterface.currentPaymentOption?.paymentType == .card
			
			return WebPaymentURLDecision(shouldLoad: shouldLoad, shouldCloseWebPaymentScreen: shouldCloseWebPaymentScreen, redirectionFinished: redirectionFinished, tapID: tapID)
		}
		
		internal func webPaymentProcessFinished(_ tapID: String) {
			
			fatalError("Must be implemented in subclasses.")
		}
		
		// MARK: - Private -
		
		fileprivate typealias Constants = __WebPaymentHandlerConstants
	}
	
	internal final class PaymentWebPaymentHandler: WebPaymentHandler {
	
		internal override func webPaymentProcessFinished(_ tapID: String) {
			
			guard
				
				let paymentOption = self.process.dataManagerInterface.currentPaymentOption,
				let chargeOrAuthorize = self.process.dataManagerInterface.currentChargeOrAuthorize,
				let paymentContentController = PaymentContentViewController.tap_findInHierarchy() else { return }
			
			LoadingView.show(in: paymentContentController, animated: true)
			
			let retryAction: TypeAlias.ArgumentlessClosure = { [weak self] in
				
				self?.webPaymentProcessFinished(tapID)
			}
			
			if chargeOrAuthorize is Charge {
				
				self.process.continuePaymentWithCurrentChargeOrAuthorize(with:								tapID,
																		 of:								Charge.self,
																		 paymentOption:						paymentOption,
																		 loader:							paymentContentController,
																		 retryAction:						retryAction,
																		 alertDismissButtonClickHandler:	nil)
			}
			else if chargeOrAuthorize is Authorize {
				
				self.process.continuePaymentWithCurrentChargeOrAuthorize(with:								tapID,
																		 of:								Authorize.self,
																		 paymentOption:						paymentOption,
																		 loader:							paymentContentController,
																		 retryAction:						retryAction,
																		 alertDismissButtonClickHandler:	nil)
			}
		}
	}
	
	internal final class CardSavingWebPaymentHandler: WebPaymentHandler {
		
		internal override func webPaymentProcessFinished(_ tapID: String) {
			
			
		}
	}
}

private struct __WebPaymentHandlerConstants {
	
	fileprivate static let returnURL = URL(string: "gosellsdk://return_url")!
	fileprivate static let tapIDKey = "tap_id"
	
	@available(*, unavailable) private init() { fatalError("This struct cannot be instantiated.") }
}
