//
//  Process+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	CoreGraphics.CGGeometry.CGRect
import struct	TapAdditionsKitV2.TypeAlias
import class PassKit.PKPaymentToken

extension Process: ProcessInterface {
    
    func showAsyncPaymentResult(_ charge: ChargeProtocol, for paymentOption: PaymentOption) {
        
    }
    
    
    func createApplePayTokenizationApiRequest(with appleTokenData: PKPaymentToken) -> CreateTokenWithApplePayRequest? {
        var token = String(data: appleTokenData.paymentData, encoding: .utf8) ?? ""
        if token == ""
        {
            token = """
{"version":"EC_v1","data":"D/LdKnlcYlgS/fzLRr6SdP1GlVAo2Dn8l+GJPyjyDhobBUzfIqVVXJws26NPG8F5Nor1d11pN40I9Dj2VW3PB9V3d2RiRI7EoMRJDiX+bZEccvkB2J8HV+2A/wgTP94qitwIn10AZ4Z2utO+q6UpW8ZBbncxDniE/4zqwgA/YYM8YnxhXQ/IzupRxD1JaAcj6mVue1XxWpw12zhqQgnCo59QSEPysCxVQoIbDnSUFd6eIj649oNLxkOztauZG0KZiK6UZjUnlRfN5Rq1ooCSPgi1gSLXyWiCAoEaQUuE/9VI1nNVhA5LBsDA96PGoQTxoXsklOFIhO+ZliwU8IMu8NMv+Q4APahmRZUHCcKYVhKcFnsyMgi6HYnNuQjWX7iLXCbbPI92HsXcF5p5XfSCcY2DG2qN190qDpUKBJwHjg==","signature":"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","header":{"ephemeralPublicKey":"MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAE2kfjdvQLxcfRS7rXFBI0vPKjL/qBOUNUgkN/JXcvpq0ACHbPWlgogvm5YZh/GBecVCu1AU1i+TSCaZ0VTnBWeg==","publicKeyHash":"LjAAyv6vb6jOEkjfG7L1a5OR2uCTHIkB61DaYdEWD+w=","transactionId":"1c072b6b9bdac6fb0757a8da8851eb1308a23a224b64b23bfb52f87e7ba6a81a"}}
"""
        }
        print("Apple Pay Token \(token)")
        if let jsonData = token.data(using: .utf8)
        {
            do {
                let dict = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
                let finalDict =  ["type": "applepay","token_data": dict] as [String : Any]
                let applePayToken:CreateTokenApplePay = try CreateTokenApplePay(dictionary: finalDict)
                let request = CreateTokenWithApplePayRequest(applePayToken: applePayToken)
                return request
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }else
        {
            return nil
        }
    }
    
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal var process: Process {
		
		if let payment: PaymentImplementation = self.wrappedImplementation.implementation() {
			
			return payment.process
		}
		else if let cardSaving: CardSavingImplementation = self.wrappedImplementation.implementation() {
			
			return cardSaving.process
		}
		else if let cardTokenization: CardTokenizationImplementation = self.wrappedImplementation.implementation() {
			
			return cardTokenization.process
		}
		else {
			
			fatalError("Wrong implementation.")
		}
	}
	
	internal var addressInputHandlerInterface: AddressInputHandlerInterface {
		
		if let payment: PaymentImplementation = self.wrappedImplementation.implementation() {
			
			return payment.addressInputHandler
		}
		else if let cardSaving: CardSavingImplementation = self.wrappedImplementation.implementation() {
			
			return cardSaving.addressInputHandler
		}
		else if let cardTokenization: CardTokenizationImplementation = self.wrappedImplementation.implementation() {
			
			return cardTokenization.addressInputHandler
		}
		else {
			
			fatalError("Wrong implementation.")
		}
	}
	
	internal var viewModelsHandlerInterface: ViewModelsHandlerInterface {
		
		if let payment: PaymentImplementation = self.wrappedImplementation.implementation() {
            //payment.viewModelsHandler.paymentOptionCellViewModels.append(EmptyTableViewCellModel())
			return payment.viewModelsHandler
		}
		else if let cardSaving: CardSavingImplementation = self.wrappedImplementation.implementation() {
			
			return cardSaving.viewModelsHandler
		}
		else if let cardTokenization: CardTokenizationImplementation = self.wrappedImplementation.implementation() {
			
			return cardTokenization.viewModelsHandler
		}
		else {
			
			fatalError("Wrong implementation.")
		}
	}
	
	internal var currencySelectionHandlerInterface: CurrencySelectionHandlerInterface {
		
		if let payment: PaymentImplementation = self.wrappedImplementation.implementation() {
			
			return payment.currencySelectionHandler
		}
		else if let cardSaving: CardSavingImplementation = self.wrappedImplementation.implementation() {
			
			return cardSaving.currencySelectionHandler
		}
		else if let cardTokenization: CardTokenizationImplementation = self.wrappedImplementation.implementation() {
		
			return cardTokenization.currencySelectionHandler
		}
		else {
			
			fatalError("Wrong implementation.")
		}
	}
	
	internal var cardScannerHandlerInterface: CardScannerHandlerInterface {
		
		if let payment: PaymentImplementation = self.wrappedImplementation.implementation() {
			
			return payment.cardScannerHandler
		}
		else if let cardSaving: CardSavingImplementation = self.wrappedImplementation.implementation() {
			
			return cardSaving.cardScannerHandler
		}
		else if let cardTokenization: CardTokenizationImplementation = self.wrappedImplementation.implementation() {
			
			return cardTokenization.cardScannerHandler
		}
		else {
			
			fatalError("Wrong implementation.")
		}
	}
	
	internal var dataManagerInterface: DataManagerInterface {
		
		if let payment: PaymentImplementation = self.wrappedImplementation.implementation() {
			
			return payment.dataManager
		}
		else if let cardSaving: CardSavingImplementation = self.wrappedImplementation.implementation() {
			
			return cardSaving.dataManager
		}
		else if let cardTokenization: CardTokenizationImplementation = self.wrappedImplementation.implementation() {
			
			return cardTokenization.dataManager
		}
		else {
			
			fatalError("Wrong implementation.")
		}
	}
	
	internal var webPaymentHandlerInterface: WebPaymentHandlerInterface {
		
		if let payment: PaymentImplementation = self.wrappedImplementation.implementation() {
			
			return payment.webPaymentHandler
		}
		else if let cardSaving: CardSavingImplementation = self.wrappedImplementation.implementation() {
			
			return cardSaving.webPaymentHandler
		}
		else {
			
			fatalError("Wrong implementation.")
		}
	}
	
	internal var buttonHandlerInterface: TapButtonHandlerInterface {
		
		if let payment: PaymentImplementation = self.wrappedImplementation.implementation() {
			
			return payment.buttonHandler
		}
		else if let cardSaving: CardSavingImplementation = self.wrappedImplementation.implementation() {
			
			return cardSaving.buttonHandler
		}
		else if let cardTokenization: CardTokenizationImplementation = self.wrappedImplementation.implementation() {
			
			return cardTokenization.buttonHandler
		}
		else {
			
			fatalError("Wrong implementation.")
		}
	}
	
	// MARK: Methods
	
	internal func showPaymentController() {
		
		if let payment: PaymentImplementation = self.wrappedImplementation.implementation() {
			
			payment.showPaymentController()
		}
		else if let cardSaving: CardSavingImplementation = self.wrappedImplementation.implementation() {
			
			cardSaving.showPaymentController()
		}
		else if let cardTokenization: CardTokenizationImplementation = self.wrappedImplementation.implementation() {
			
			cardTokenization.showPaymentController()
		}
		else {
			
			fatalError("Wrong implementation.")
		}
	}
	
	internal func showLoadingController(_ coveringHeader: Bool) -> LoadingViewController {
		
		if let payment: PaymentImplementation = self.wrappedImplementation.implementation() {
			
			return payment.showLoadingController(coveringHeader)
		}
		else if let cardSaving: CardSavingImplementation = self.wrappedImplementation.implementation() {
			
			return cardSaving.showLoadingController(coveringHeader)
		}
		else {
			
			fatalError("Wrong implementation.")
		}
	}
	
	internal func closePayment(with status: PaymentStatus, fadeAnimation: Bool, force: Bool, completion: TypeAlias.ArgumentlessClosure?) {
		
		if let payment: PaymentImplementation = self.wrappedImplementation.implementation() {
			
			return payment.closePayment(with: status, fadeAnimation: fadeAnimation, force: force, completion: completion)
		}
		else if let cardSaving: CardSavingImplementation = self.wrappedImplementation.implementation() {
			
			return cardSaving.closePayment(with: status, fadeAnimation: fadeAnimation, force: force, completion: completion)
		}
		else if let cardTokenization: CardTokenizationImplementation = self.wrappedImplementation.implementation() {
			
			return cardTokenization.closePayment(with: status, fadeAnimation: fadeAnimation, force: force, completion: completion)
		}
		else {
			
			fatalError("Wrong implementation.")
		}
	}
	
	internal func paymentOptionsControllerKeyboardLayoutFinished() {
		
		if let payment: PaymentImplementation = self.wrappedImplementation.implementation() {
			
			payment.paymentOptionsControllerKeyboardLayoutFinished()
		}
		else if let cardSaving: CardSavingImplementation = self.wrappedImplementation.implementation() {
			
			cardSaving.paymentOptionsControllerKeyboardLayoutFinished()
		}
		else {
			
			fatalError("Wrong implementation.")
		}
	}
	
	internal func startPayment(with paymentOption: PaymentOptionCellViewModel) {
		
		if let payment: PaymentImplementation = self.wrappedImplementation.implementation() {
			
			payment.startPayment(with: paymentOption)
		}
		else {
			
			fatalError("Wrong implementation.")
		}
	}
	
	internal func openOTPScreen(with phoneNumber: String, for paymentOption: PaymentOption) {
		
		if let payment: PaymentImplementation = self.wrappedImplementation.implementation() {
			
			payment.openOTPScreen(with: phoneNumber, for: paymentOption)
		}
		else {
			
			fatalError("Wrong implementation.")
		}
	}
	
	internal func loadingControllerFrame(coveringHeader: Bool) -> CGRect {
		
		if let payment: PaymentImplementation = self.wrappedImplementation.implementation() {
			
			return payment.loadingControllerFrame(coveringHeader: coveringHeader)
		}
		else if let cardSaving: CardSavingImplementation = self.wrappedImplementation.implementation() {
			
			return cardSaving.loadingControllerFrame(coveringHeader: coveringHeader)
		}
		else {
			
			fatalError("Wrong implementation.")
		}
	}
	
	internal func paymentSuccess(with chargeOrAuthorize: ChargeProtocol) {
		
		if let payment: PaymentImplementation = self.wrappedImplementation.implementation() {
			
			payment.paymentSuccess(with: chargeOrAuthorize)
		}
		else {
			
			fatalError("Wrong implementation.")
		}
	}
	
	internal func paymentFailure(with status: ChargeStatus, chargeOrAuthorize: ChargeProtocol, error: TapSDKError?) {
		
		if let payment: PaymentImplementation = self.wrappedImplementation.implementation() {
			
			payment.paymentFailure(with: status, chargeOrAuthorize: chargeOrAuthorize, error: error)
		}
		else {
			
			fatalError("Wrong implementation.")
		}
	}
	
	internal func cardSavingSuccess(with cardVerification: CardVerification) {
		
		if let cardSaving: CardSavingImplementation = self.wrappedImplementation.implementation() {
			
			cardSaving.cardSavingSuccess(with: cardVerification)
		}
		else {
			
			fatalError("Wrong implementation.")
		}
	}
	
	internal func cardSavingFailure(with cardVerification: CardVerification, error: TapSDKError?) {
		
		if let cardSaving: CardSavingImplementation = self.wrappedImplementation.implementation() {
			
			cardSaving.cardSavingFailure(with: cardVerification, error: error)
		}
		else {
			
			fatalError("Wrong implementation.")
		}
	}
	
	internal func cardTokenizationSuccess(with token: Token, customerRequestedToSaveCard: Bool) {
		
		if let tokenization: CardTokenizationImplementation = self.wrappedImplementation.implementation() {
			
			tokenization.cardTokenizationSuccess(with: token, customerRequestedToSaveCard: customerRequestedToSaveCard)
		}
		else {
			
			fatalError("Wrong implementation")
		}
	}
	
	internal func cardTokenizationFailure(with error: TapSDKError) {
		
		if let cardTokenization: CardTokenizationImplementation = self.wrappedImplementation.implementation() {
			
			cardTokenization.cardTokenizationFailure(with: error)
		}
		else {
			
			fatalError("Wrong implementation")
		}
	}
	
	internal func openPaymentURL(_ url: URL, for paymentOption: PaymentOption, binNumber: String?) {
		
		if let payment: PaymentImplementation = self.wrappedImplementation.implementation() {
			
			payment.openPaymentURL(url, for: paymentOption, binNumber: binNumber)
		}
		else if let cardSaving: CardSavingImplementation = self.wrappedImplementation.implementation() {
			
			cardSaving.openPaymentURL(url, for: paymentOption, binNumber: binNumber)
		}
		else {
			
			fatalError("Wrong implementation.")
		}
	}
	
	internal func continuePaymentWithCurrentChargeOrAuthorize<T>(with identifier: String, of type: T.Type, paymentOption: PaymentOption, loader: LoadingViewSupport?, retryAction: @escaping TypeAlias.ArgumentlessClosure, alertDismissButtonClickHandler: TypeAlias.ArgumentlessClosure?) where T : ChargeProtocol {
		
		if let payment: PaymentImplementation = self.wrappedImplementation.implementation() {
			
			payment.continuePaymentWithCurrentChargeOrAuthorize(with: identifier, of: type, paymentOption: paymentOption, loader: loader, retryAction: retryAction, alertDismissButtonClickHandler: alertDismissButtonClickHandler)
		}
		else if let cardSaving: CardSavingImplementation = self.wrappedImplementation.implementation() {
			
			cardSaving.continuePaymentWithCurrentChargeOrAuthorize(with: identifier, of: type, paymentOption: paymentOption, loader: loader, retryAction: retryAction, alertDismissButtonClickHandler: alertDismissButtonClickHandler)
		}
		else {
			
			fatalError("Wrong implementation.")
		}
	}
	
	internal func continueCardSaving(with identifier: String, paymentOption: PaymentOption, binNumber: String?, loader: LoadingViewSupport?, retryAction: @escaping TypeAlias.ArgumentlessClosure, alertDismissButtonClickHandler: TypeAlias.ArgumentlessClosure?) {
		
		if let payment: PaymentImplementation = self.wrappedImplementation.implementation() {
			
			payment.continueCardSaving(with: identifier, paymentOption: paymentOption, binNumber: binNumber, loader: loader, retryAction: retryAction, alertDismissButtonClickHandler: alertDismissButtonClickHandler)
		}
		else if let cardSaving: CardSavingImplementation = self.wrappedImplementation.implementation() {
			
			cardSaving.continueCardSaving(with: identifier, paymentOption: paymentOption, binNumber: binNumber, loader: loader, retryAction: retryAction, alertDismissButtonClickHandler: alertDismissButtonClickHandler)
		}
		else {
			
			fatalError("Wrong implementation.")
		}
	}
	
	// MARK: - Private -
	
	private typealias PaymentImplementation				= Implementation<PaymentClass>
	private typealias CardSavingImplementation			= Implementation<CardSavingClass>
	private typealias CardTokenizationImplementation	= Implementation<CardTokenizationClass>
}
