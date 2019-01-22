//
//  PaymentProcess.WebPaymentHandler.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	TapAdditionsKit.TypeAlias

internal extension PaymentProcess {
	
	internal class WebPaymentHandler: ProcessHandlerInterface {
		
		// MARK: - Internal -
		// MARK: Properties
		
		internal var returnURL: URL {
			
			return Constants.returnURL
		}
		
		// MARK: Methods
		
		internal required init(process: PaymentProcess) {
			
			self.process = process
		}
		
		internal func prepareWebPaymentController(_ controller: WebPaymentViewController) {
			
			guard let paymentOption = self.process.dataManager.currentPaymentOption else {
				
				fatalError("This code should never be executed.")
			}
			
			var binInformation: BINResponse? = nil
			if let binNumber = self.process.dataManager.currentPaymentCardBINNumber {
				
				binInformation = BINDataManager.shared.cachedBINData(for: binNumber)
			}
			
			controller.setup(with: paymentOption, url: self.process.dataManager.urlToLoadInWebPaymentController, binInformation: binInformation)
		}
		
		internal func decision(forWebPayment url: URL) -> WebPaymentURLDecision {
			
			let urlIsReturnURL = url.absoluteString.starts(with: Constants.returnURL.absoluteString)
			
			let shouldLoad = !urlIsReturnURL
			let redirectionFinished = urlIsReturnURL
			let tapID = url[Constants.tapIDKey]
			let shouldCloseWebPaymentScreen = redirectionFinished && self.process.dataManager.currentPaymentOption?.paymentType == .card
			
			return WebPaymentURLDecision(shouldLoad: shouldLoad, shouldCloseWebPaymentScreen: shouldCloseWebPaymentScreen, redirectionFinished: redirectionFinished, tapID: tapID)
		}
		
		internal func webPaymentProcessFinished(_ chargeOrAuthorizeID: String) {
			
			guard
				
				let paymentOption = self.process.dataManager.currentPaymentOption,
				let chargeOrAuthorize = self.process.dataManager.currentChargeOrAuthorize,
				let paymentContentController = PaymentContentViewController.tap_findInHierarchy() else { return }
			
			LoadingView.show(in: paymentContentController, animated: true)
			
			let retryAction: TypeAlias.ArgumentlessClosure = { [weak self] in
				
				self?.webPaymentProcessFinished(chargeOrAuthorizeID)
			}
			
			if chargeOrAuthorize is Charge {
				
				self.process.continuePaymentWithCurrentChargeOrAuthorize(with:								chargeOrAuthorizeID,
																		 of:								Charge.self,
																		 paymentOption:						paymentOption,
																		 loader:							paymentContentController,
																		 retryAction:						retryAction,
																		 alertDismissButtonClickHandler:	nil)
			}
			else if chargeOrAuthorize is Authorize {
				
				self.process.continuePaymentWithCurrentChargeOrAuthorize(with:								chargeOrAuthorizeID,
																		 of:								Authorize.self,
																		 paymentOption:						paymentOption,
																		 loader:							paymentContentController,
																		 retryAction:						retryAction,
																		 alertDismissButtonClickHandler:	nil)
			}
			else {
				
				return
			}
		}
		
		// MARK: - Private -
		
		private struct Constants {
			
			fileprivate static let returnURL = URL(string: "gosellsdk://return_url")!
			fileprivate static let tapIDKey = "tap_id"
			
			@available(*, unavailable) private init() {}
		}
		
		// MARK: Properties
		
		private unowned let process: PaymentProcess
	}
}
