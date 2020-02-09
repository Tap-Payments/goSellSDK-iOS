//
//  Process+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	CoreGraphics.CGGeometry.CGRect
import struct	TapAdditionsKit.TypeAlias
import class PassKit.PKPaymentToken

extension Process: ProcessInterface {
    
    func createApplePayTokenizationApiRequest(with appleTokenData: PKPaymentToken) -> CreateTokenWithApplePayRequest? {
        var token = String(data: appleTokenData.paymentData, encoding: .utf8) ?? ""
        if token == ""
        {
            token = "{\"version\":\"EC_v1\",\"data\":\"P4b0dVwlBbULo6RDUGb765/i5/lChVPhl6t1M2FqGlIlr6k+azXGsLkj+Bam1ZCPVDQ6Oy19iIqHrlo/6kkKb0gk+2qb/DM7jZuEWooHr+FT+lKN/Tel1622yIgqR3gA9KqbqNbJzWFuWkINEUrtk2rANJGYjLLqfaAq8vfLsrU+fAu1WfJy0pMyFiNGtD3H6woEl+yhhW8akFoZY7073Fg1TnXZ2buJXbViSgaTXYqoqrtPkunAN4y3/VSJzj/e5oiYclFK7zl0sYN2ZYml7w/QrbxVc5VxFdwcqaZ2BhqksNMSUZPwBqWEF+Yc/6+MHE47iYkybycGIo5J2J59mnhTVzv2FecZRky1+FPRDzorIe6klcFEg3MoDt0v7+XzbeqIj7F24yACLwxx\",\"signature\":\"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\",\"header\":{\"ephemeralPublicKey\":\"MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEN9RokExCu/+w1aQ3OB49yGX98eqVfq/vBnrCiqwtq1bY3Gg2d5GaE+A1cm74LzsGbXjdG09+q34s60K2FVm7Ag==\",\"publicKeyHash\":\"LjAAyv6vb6jOEkjfG7L1a5OR2uCTHIkB61DaYdEWD+w=\",\"transactionId\":\"cb3e8c9e65d33efecbe0681fa77fd3857431653c485d5b68b50ab9590c394264\"}}"
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
