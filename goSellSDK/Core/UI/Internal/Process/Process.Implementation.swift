//
//  Process.Implementation.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	CoreGraphics.CGGeometry.CGRect
import protocol	TapAdditionsKitV2.ClassProtocol
import struct	TapAdditionsKitV2.TypeAlias
import class	UIKit.UIResponder.UIResponder
import class	UIKit.UIScreen.UIScreen
import PassKit

internal extension Process {
	
	typealias Implementation = __ProcessImplementation
}

internal class __ProcessImplementation<HandlerMode: ProcessMode>: NSObject, ProcessGenericInterface {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal unowned let process: Process
	
	internal private(set) lazy var dataManager: Process.DataManager = {
		
		if HandlerMode.self is Payment.Type {
			
			return Process.PaymentDataManager(process: self)
		}
		else if HandlerMode.self is CardSaving.Type {
			
			return Process.CardSavingDataManager(process: self)
		}
		else if HandlerMode.self is CardTokenization.Type {
			
			return Process.CardTokenizationDataManager(process: self)
		}
		else {
			
			fatalError("Unknown mode")
		}
	}()
	
	internal private(set) lazy var viewModelsHandler: Process.ViewModelsHandler = {
		
		if HandlerMode.self is Payment.Type {
			
			return Process.PaymentViewModelsHandler(process: self)
		}
		else if HandlerMode.self is CardSaving.Type {
			
			return Process.CardSavingViewModelsHandler(process: self)
		}
		else if HandlerMode.self is CardTokenization.Type {
			
			return Process.CardTokenizationViewModelsHandler(process: self)
		}
		else {
			
			fatalError("Unknown mode")
		}
	}()
	
	internal private(set) lazy var currencySelectionHandler: Process.CurrencySelectionHandler = {
		
		if HandlerMode.self is Payment.Type {
			
			return Process.PaymentCurrencySelectionHandler(process: self)
		}
		else {
			
			fatalError("Unknown mode")
		}
	}()
	
	internal private(set) lazy var cardScannerHandler	= Process.CardScannerHandler(process: self)
	internal private(set) lazy var addressInputHandler	= Process.AddressInputHandler(process: self)
	internal private(set) lazy var otpHandler			= Process.OTPHandler(process: self)
	internal private(set) lazy var webPaymentHandler	= Process.WebPaymentHandler(process: self)
	internal private(set) lazy var buttonHandler		= Process.TapButtonProcessHandler	<HandlerMode, __ProcessImplementation>(process: self)
	
	
	internal var dataManagerInterface: DataManagerInterface { return self.dataManager }
	internal var viewModelsHandlerInterface: ViewModelsHandlerInterface { return self.viewModelsHandler }
	internal var buttonHandlerInterface: TapButtonHandlerInterface { return self.buttonHandler }
	internal var webPaymentHandlerInterface: WebPaymentHandlerInterface { return self.webPaymentHandler }
	
	// MARK: Methods
	
	internal func startPayment(with paymentOption: PaymentOptionCellViewModel) {
		
		fatalError("Should be implemented in subclass.")
	}
	
	internal func openOTPScreen(with phoneNumber: String, for paymentOption: PaymentOption) {
		
		fatalError("Should be implemented in subclass.")
	}
	
	internal func openPaymentURL(_ url: URL, for paymentOption: PaymentOption, binNumber: String?) {
		
		self.dataManager.urlToLoadInWebPaymentController = url
		self.openWebPaymentScreen(for: paymentOption, url: url, binNumber: binNumber)
	}
    
    internal func showAsyncPaymentResult(_ charge: ChargeProtocol, for paymentOption: PaymentOption) {
        self.openAsyncPaymentScreen(for: paymentOption, charge: charge)
    }
	
	internal func continuePaymentWithCurrentChargeOrAuthorize<T>(with identifier: String, of type: T.Type, paymentOption: PaymentOption, loader: LoadingViewSupport?, retryAction: @escaping TypeAlias.ArgumentlessClosure, alertDismissButtonClickHandler: TypeAlias.ArgumentlessClosure?) where T : ChargeProtocol {
		
		fatalError("Should be implemented in subclass.")
	}
	
	func continueCardSaving(with identifier: String, paymentOption: PaymentOption, binNumber: String?, loader: LoadingViewSupport?, retryAction: @escaping TypeAlias.ArgumentlessClosure, alertDismissButtonClickHandler: TypeAlias.ArgumentlessClosure?) {
		
		fatalError("Should be implemented in subclass.")
	}
	
	internal func paymentSuccess(with chargeOrAuthorize: ChargeProtocol) {
		
		fatalError("Should be implemented in subclass.")
	}
	
	internal func paymentFailure(with status: ChargeStatus, chargeOrAuthorize: ChargeProtocol, error: TapSDKError?) {
		
		fatalError("Should be implemented in subclass.")
	}
	
	internal func cardSavingSuccess(with cardVerification: CardVerification) {
		
		fatalError("Should be implemented in subclass.")
	}
	
	internal func cardSavingFailure(with cardVerification: CardVerification, error: TapSDKError?) {
		
		fatalError("Should be implemented in subclass.")
	}
	
	internal func cardTokenizationSuccess(with token: Token, customerRequestedToSaveCard: Bool) {
		
		fatalError("Should be implemented in subclass.")
	}
	
	internal func cardTokenizationFailure(with error: TapSDKError) {
		
		fatalError("Should be implemented in subclass.")
	}
	
	required internal init(process: Process) {
		
		self.process = process
	}
	
	internal static func with<T: ProcessModeClass>(process: Process, mode: T.Type) -> Process.Implementation<T>  {
		
		if mode is Payment.Type {
			
			return PaymentImplementation<T>(process: process)
		}
		else if mode is CardSaving.Type {
			
			return CardSavingImplementation<T>(process: process)
		}
		else if mode is CardTokenization.Type {
			
			return CardTokenizationImplementation(process: process)
		}
		else {
			
			fatalError("Unknown mode.")
		}
	}
	
	internal func loadingControllerFrame(coveringHeader: Bool) -> CGRect {
		
		let currentController = ResizablePaymentContainerViewController.tap_findInHierarchy()?.currentContentViewController as? NavigationContentViewController
		
		let topOffset = currentController?.contentTopOffset ?? 0.0
		let screenBounds = UIScreen.main.bounds
		var result = screenBounds
		result.origin.y += topOffset
		result.size.height -= topOffset
		
		return result
	}
	
	internal func showPaymentController() {
		
		let controller = PaymentViewController.instantiate()
	
		controller.tap_showOnSeparateWindow(below: .tap_statusBar) { [unowned controller] (rootController) in
			
			rootController.allowedInterfaceOrientations = .portrait
			rootController.preferredInterfaceOrientation = .portrait
			rootController.canAutorotate = false
			
			rootController.present(controller, animated: false, completion: nil)
		}
	}
	
	internal func showLoadingController(_ coveringHeader: Bool) -> LoadingViewController {
		
		let loaderFrame = self.loadingControllerFrame(coveringHeader: coveringHeader)
		let loader = LoadingViewController.show(topOffset: loaderFrame.minY)
		
		return loader
	}
	
	internal func paymentOptionsControllerKeyboardLayoutFinished() {
		
		self.viewModelsHandler.scrollToSelectedModel()
	}
	
	internal func closePayment(with status: PaymentStatus, fadeAnimation: Bool, force: Bool, completion: TypeAlias.ArgumentlessClosure?) {
		
		fatalError("Should be implemented in subclasses")
	}
	
	// MARK: - Private -
	// MARK: Methods
	
	fileprivate func closeWebPaymentScreen() {
		
		if let popupController = WebPaymentPopupViewController.tap_findInHierarchy() {
			
			popupController.hide()
		}
		
		if let pushedController = WebPaymentViewController.tap_findInHierarchy() {
			
			pushedController.navigationController?.popViewController(animated: true)
		}
	}
	
	fileprivate func showCancelPaymentAlert(with decision: @escaping TypeAlias.BooleanClosure) {
		
		let alert = TapAlertController(titleKey: 		.alert_cancel_payment_status_undefined_title,
									   messageKey: 		.alert_cancel_payment_status_undefined_message,
									   preferredStyle:	.alert)
		
		let cancelCancelAction = TapAlertController.Action(titleKey: .alert_cancel_payment_status_undefined_btn_no_title, style: .cancel) { [weak alert] (action) in
			
			alert?.hide()
			decision(false)
		}
		
		let confirmCancelAction = TapAlertController.Action(titleKey: .alert_cancel_payment_status_undefined_btn_confirm_title, style: .destructive) { [weak alert] (action) in
			
			alert?.hide()
			decision(true)
		}
		
		alert.addAction(cancelCancelAction)
		alert.addAction(confirmCancelAction)
		
		alert.show()
	}
	
	fileprivate func showSuccessPopup(with subtitle: String, completion: @escaping TypeAlias.ArgumentlessClosure) {
		
		if !self.canShowStatusPopup {
			
			completion()
			return
		}
		
		let disappearanceTime = (SettingsDataManager.shared.settings?.internalSettings ?? InternalSDKSettings.default).statusDisplayDuration
		
		let popup           = StatusPopupViewController.shared
		popup.titleText     = LocalizationManager.shared.localizedString(for: .payment_status_alert_successful)
		popup.subtitleText  = subtitle
		popup.success		= true
		
		popup.display { [weak popup] in
			
			popup?.idleDisappearanceTimeInterval = disappearanceTime
			completion()
		}
	}
	
	fileprivate func showFailurePopup(_ completion: @escaping TypeAlias.ArgumentlessClosure) {
		
		if !self.canShowStatusPopup {
			
			completion()
			return
		}
		
		let disappearanceTime = (SettingsDataManager.shared.settings?.internalSettings ?? InternalSDKSettings.default).statusDisplayDuration
		
		let popup           = StatusPopupViewController.shared
		popup.titleText     = LocalizationManager.shared.localizedString(for: .payment_status_alert_failed)
		popup.subtitleText  = nil
		popup.success		= false
		
		popup.display { [weak popup] in
			
			popup?.idleDisappearanceTimeInterval = disappearanceTime
			completion()
		}
	}
	
	fileprivate func forceClosePayment(withFadeAnimation: Bool, completion: TypeAlias.ArgumentlessClosure?) {
		
		var sharedProcess: Process? = Process.shared
		
		let localCompletion: TypeAlias.ArgumentlessClosure = {
			
			completion?()
			
			if sharedProcess != nil {
				
				type(of: sharedProcess!).destroyInstance()
				sharedProcess = nil
			}
		}
		
		KnownStaticallyDestroyableTypes.destroyAllDelayedDestroyableInstances {
			
			if let paymentContentController = PaymentContentViewController.tap_findInHierarchy() {
				
				paymentContentController.hide(usingFadeAnimation: withFadeAnimation) {
					
					Process.paymentClosed()
					localCompletion()
				}
			}
			else {
				
				Process.paymentClosed()
				localCompletion()
			}
		}
	}
	
    fileprivate func openAsyncPaymentScreen(for paymentOption: PaymentOption, charge: ChargeProtocol, completion: TypeAlias.ArgumentlessClosure? = nil) {
        self.dataManager.currentPaymentOption            = paymentOption
        
        ResizablePaymentContainerViewController.tap_findInHierarchy()?.makeFullscreen {
            let asyncControllerFrame = PaymentOptionsViewController.tap_findInHierarchy()?.view.frame ?? UIScreen.main.bounds//self.process.loadingControllerFrame(coveringHeader: true)
            AsyncResponseViewController.show(with: asyncControllerFrame.minY, with: charge, for: paymentOption)
        }
    }
    
	fileprivate func openWebPaymentScreen(for paymentOption: PaymentOption, url: URL?, binNumber: String?, completion: TypeAlias.ArgumentlessClosure? = nil) {
		
		self.dataManager.currentPaymentOption			= paymentOption
		self.dataManager.currentPaymentCardBINNumber	= binNumber
		
		switch paymentOption.paymentType {
			
		case .card:
			
			guard let nonnullURL = url else {
				
				completion?()
				return
			}
			
			ResizablePaymentContainerViewController.tap_findInHierarchy()?.makeFullscreen { [weak self] in
				
				guard let strongSelf = self else {
					
					completion?()
					return
				}
				
				let webPopupControllerFrame = strongSelf.loadingControllerFrame(coveringHeader: false)
				
				WebPaymentPopupViewController.show(with: webPopupControllerFrame.minY, with: nonnullURL, completion: completion)
			}
			
		case .web:
			
			if let alreadyOpenedWebPaymentController = WebPaymentViewController.tap_findInHierarchy() {
				
				self.webPaymentHandler.prepareWebPaymentController(alreadyOpenedWebPaymentController)
				completion?()
			}
			else {
				
				PaymentOptionsViewController.tap_findInHierarchy()?.showWebPaymentViewController(completion)
			}
        case .apple,.device:
            guard let nonnullURL = url else {
                
                completion?()
                return
            }
            
            ResizablePaymentContainerViewController.tap_findInHierarchy()?.makeFullscreen { [weak self] in
                
                guard let strongSelf = self else {
                    
                    completion?()
                    return
                }
                
                let webPopupControllerFrame = strongSelf.loadingControllerFrame(coveringHeader: false)
                
                WebPaymentPopupViewController.show(with: webPopupControllerFrame.minY, with: nonnullURL, completion: completion)
            }
		case .all:
			print("paymentType always web or card or apple pay")

		}
	}
	
	fileprivate func reportDelegateOnPaymentCompletion(with status: PaymentStatus) {
		
		guard let session = self.process.externalSession, let delegate = session.delegate else { return }
		
		switch status {
			
		case .cancelled:
			
			delegate.sessionCancelled?(session)
			
		case .successfulCharge(let charge):
			
			delegate.paymentSucceed?(charge, on: session)
			
		case .successfulAuthorize(let authorize):
			
			delegate.authorizationSucceed?(authorize, on: session)
			
		case .successfulCardSave(let cardVerification):
			
			delegate.cardSaved?(cardVerification, on: session)
			
		case .successfulCardTokenize(let token, let saveCard):
			
			delegate.cardTokenized?(token, on: session, customerRequestedToSaveTheCard: saveCard)
			
		case .chargeFailure(let charge, let error):
			
			delegate.paymentFailed?(with: charge, error: error, on: session)
			
		case .authorizationFailure(let authorize, let error):
			
			delegate.authorizationFailed?(with: authorize, error: error, on: session)
			
		case .cardSaveFailure(let verification, let error):
			
			delegate.cardSavingFailed?(with: verification, error: error, on: session)
			
		case .cardTokenizeFailure(let error):
			
			delegate.cardTokenizationFailed?(with: error, on: session)
		}
	}
	
	private var canShowStatusPopup: Bool {
		
		if let session = self.process.externalSession, let value = session.appearance?.sessionShouldShowStatusPopup?(session) {
			
			return value
		}
		else {
			
			return true
		}
	}
}

internal final class PaymentImplementation<HandlerMode: ProcessMode>: Process.Implementation<HandlerMode>, PKPaymentAuthorizationViewControllerDelegate,SetupApplePayViewControllerDelegate {
    
    func setupApplePayViewControllerSetpButtonTouchUpInside(_ controller: SetupApplePayViewController) {
         controller.dismiss(animated: true) {
             let library = PKPassLibrary()
             library.openPaymentSetup()
         }
     }
     
     func setupApplePayViewControllerDidCancel(_ controller: SetupApplePayViewController) {
         controller.dismiss(animated: true, completion: nil)
     }
     
    
     func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
         controller.dismiss(animated: true) {
             if let session:SessionProtocol = Process.shared.externalSession
             {
                 session.delegate?.applePaymentCanceled?(on: session)
             }
            
             //guard let strongSelf = self else { return }
            //self?.dataManager.ale showMissingInformationAlert(with: "Payment Canceled", message: "User did not authorize the payment.")
            //self?.closePayment(with: .cancelled, fadeAnimation: false, force: true, completion: nil)
         }
     }
     
     @available(iOS 11.0, *)
     func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
        controller.dismiss(animated: true) {[weak self] in
            self?.startPayment(with: payment.token)
            
            /*if let session:SessionProtocol = Process.shared.externalSession
            {
                session.delegate?.applePaymentSucceed?("Method: \(paymentMethod.uppercased())\nTransID: \(transactionID)\nEncodedData: \(token)", on: session)
            }*/
        }
     }
    
	
	// MARK: - Internal -
	// MARK: Methods
	
	internal override func startPayment(with paymentOption: PaymentOptionCellViewModel) {
		
		let amount = self.dataManager.selectedCurrency
		let extraFees = paymentOption.paymentOption?.extraFees ?? []
		let extraFeesAmount = AmountedCurrency(amount.currency, Process.AmountCalculator<PaymentClass>.extraFeeAmount(from: extraFees, in: amount))
		if extraFeesAmount.amount > 0.0 {
			
			self.showExtraFeesPaymentAlert(with: amount, extraFeesAmount: extraFeesAmount) { (shouldProcessPayment) in
				
				if shouldProcessPayment {
					
					self.forceStartPayment(with: paymentOption)
				}
				else {
					
					self.viewModelsHandler.deselectAllPaymentOptionsModels()
				}
			}
		}
		else {
			
			self.forceStartPayment(with: paymentOption)
		}
	}
	
	internal override func continuePaymentWithCurrentChargeOrAuthorize<T: ChargeProtocol>(with identifier: String, of type: T.Type, paymentOption: PaymentOption, loader: LoadingViewSupport?, retryAction: @escaping TypeAlias.ArgumentlessClosure, alertDismissButtonClickHandler: TypeAlias.ArgumentlessClosure?) {
		
		APIClient.shared.retrieveObject(with: identifier) { (returnChargeOrAuthorize: T?, error: TapSDKError?) in
			
			loader?.hideLoader()
			
			self.dataManager.handleChargeOrAuthorizeResponse(returnChargeOrAuthorize,
															 error:                             error,
															 paymentOption:                     paymentOption,
															 cardBIN:                           nil,
															 retryAction:                       retryAction,
															 alertDismissButtonClickHandler:    alertDismissButtonClickHandler)
		}
	}
	
	internal override func openOTPScreen(with phoneNumber: String, for paymentOption: PaymentOption) {
		
		self.dataManager.currentPaymentOption = paymentOption
		self.otpHandler.showOTPScreen(with: phoneNumber)
	}
	
	internal override func paymentSuccess(with chargeOrAuthorize: ChargeProtocol) {
		
		let popupAppearanceCompletionClosure: TypeAlias.ArgumentlessClosure = { [weak self] in
			
			if let authorize = chargeOrAuthorize as? Authorize {
				
				self?.closePayment(with: .successfulAuthorize(authorize), fadeAnimation: true, force: false, completion: nil)
			}
			else if let charge = chargeOrAuthorize as? Charge {
				
				self?.closePayment(with: .successfulCharge(charge), fadeAnimation: true, force: false, completion: nil)
			}
		}
		
		guard let receiptNumber = chargeOrAuthorize.receiptSettings?.identifier else {
			
			popupAppearanceCompletionClosure()
			return
		}
		
		self.showSuccessPopup(with: receiptNumber, completion: popupAppearanceCompletionClosure)
	}
	
	internal override func paymentFailure(with status: ChargeStatus, chargeOrAuthorize: ChargeProtocol, error: TapSDKError?) {
		
		let completion: TypeAlias.ArgumentlessClosure = {
			
			if let authorize = chargeOrAuthorize as? Authorize {
				
				self.closePayment(with: .authorizationFailure(authorize, error), fadeAnimation: false, force: false, completion: nil)
			}
			else if let charge = chargeOrAuthorize as? Charge {
				
				self.closePayment(with: .chargeFailure(charge, error), fadeAnimation: false, force: false, completion: nil)
			}
			else {
				
				fatalError("Impossible case")
			}
		}
		
		self.showFailurePopup(completion)
	}
	
	internal override func closePayment(with status: PaymentStatus, fadeAnimation: Bool, force: Bool, completion: TypeAlias.ArgumentlessClosure?) {
		
		let beforeCloseCompletion: TypeAlias.BooleanClosure =  { (willClose) in
			
			if willClose {
				
				self.reportDelegateOnPaymentCompletion(with: status)
			}
		}
		
		let localCompletion: TypeAlias.BooleanClosure = { (closed) in
			
			completion?()
		}
		
		if self.dataManagerInterface.isCallingPaymentAPI || self.dataManagerInterface.isChargeOrAuthorizeInProgress  {
			
			let alertDecision: TypeAlias.BooleanClosure = { (shouldClose) in
				
				beforeCloseCompletion(shouldClose)
				
				if shouldClose {
					
					self.forceClosePayment(withFadeAnimation: fadeAnimation) {
						
						localCompletion(true)
					}
				}
				else {
					
					localCompletion(false)
				}
			}
			
			if force {
				
				alertDecision(true)
			}
			else {
				
				self.showCancelPaymentAlert(with: alertDecision)
			}
		}
		else {
			
			beforeCloseCompletion(true)
			
			self.forceClosePayment(withFadeAnimation: fadeAnimation) {
				
				localCompletion(true)
			}
		}
	}
	
	// MARK: - Private -
	// MARK: Methods
	
	private func forceStartPayment(with paymentOption: PaymentOptionCellViewModel) {
		
		if let savedCardPaymentOption = paymentOption as? CardCollectionViewCellModel {
			
			let card = savedCardPaymentOption.card
			let paymentOption = paymentOption.paymentOption ?? self.dataManager.paymentOption(for: card)
			self.startPayment(with: card, paymentOption: paymentOption)
		}
		else if let webPaymentOption = paymentOption as? WebPaymentOptionTableViewCellModel {
			
			self.startPayment(withWebPaymentOption: webPaymentOption.paymentOption)
		}
        else if let applePaymentOption = paymentOption as? ApplePaymentOptionTableViewCellModel {
            
            self.startPayment(withApplePaymentOption: applePaymentOption.paymentOption)
        }
		else if let cardPaymentOption = paymentOption as? CardInputTableViewCellModel, let card = cardPaymentOption.card {
			
			guard let selectedPaymentOption = cardPaymentOption.selectedPaymentOption else {
				
				fatalError("Selected payment option is not defined.")
			}
			
			self.startPaymentProcess(with: card, paymentOption: selectedPaymentOption, saveCard: cardPaymentOption.shouldSaveCard)
		}
	}
	
	private func showExtraFeesPaymentAlert(with plainAmount: AmountedCurrency, extraFeesAmount: AmountedCurrency, decision: @escaping TypeAlias.BooleanClosure) {
		
		UIResponder.tap_resign {
			
			let totalAmount = AmountedCurrency(plainAmount.currency, plainAmount.amount + extraFeesAmount.amount, plainAmount.currencySymbol)
			
			let extraFeesAmountText = CurrencyFormatter.shared.format(extraFeesAmount)
			let totalAmountText 	= CurrencyFormatter.shared.format(totalAmount)
			
			let alert = TapAlertController(titleKey: 		.alert_extra_charges_title,
										   messageKey: 		.alert_extra_charges_message, extraFeesAmountText, totalAmountText,
										   preferredStyle:	.alert)
			
			let cancelAction = TapAlertController.Action(titleKey: .alert_extra_charges_btn_cancel_title, style: .cancel) { [weak alert] (action) in
				
				alert?.hide()
				decision(false)
			}
			
			let confirmAction = TapAlertController.Action(titleKey: .alert_extra_charges_btn_confirm_title, style: .default) { [weak alert] (action) in
				
				alert?.hide()
				decision(true)
			}
			
			alert.addAction(cancelAction)
			alert.addAction(confirmAction)
			
			alert.show()
		}
	}
	
	private func startPayment(with savedCard: SavedCard, paymentOption: PaymentOption) {
		
		guard let customerIdentifier = self.process.externalSession?.dataSource?.customer?.identifier, let cardIdentifier = savedCard.identifier else { return }
		
		let card = CreateTokenSavedCard(cardIdentifier: cardIdentifier, customerIdentifier: customerIdentifier)
		let request = CreateTokenWithSavedCardRequest(savedCard: card)
		
		self.dataManager.callTokenAPI(with: request, paymentOption: paymentOption, saveCard: nil)
	}
	
	private func startPaymentProcess(with card: CreateTokenCard, paymentOption: PaymentOption, saveCard: Bool) {
		
		let request = CreateTokenWithCardDataRequest(card: card)
		self.dataManager.callTokenAPI(with: request, paymentOption: paymentOption, saveCard: saveCard)
	}
    
    private func startPayment(with appleTokenData: PKPaymentToken) {
        let paymentOption:PaymentOption = self.dataManager.paymentOption(for: .apple)
        
        if let tokenApiRequest = Process.shared.createApplePayTokenizationApiRequest(with: appleTokenData)
        {
            self.dataManager.callTokenAPI(with: tokenApiRequest, paymentOption: paymentOption, saveCard: nil)
        }else
        {
            self.process.buttonHandlerInterface.stopButtonLoader()
        }
    }
    
    private func startPayment(withWebPaymentOption paymentOption: PaymentOption) {
        
        if paymentOption.isAsync
        {
            startPaymentHelperAsync(withWebPaymentOption: paymentOption)
        }else
        {
            startPaymentHelperWeb(withWebPaymentOption: paymentOption)
        }
    }
    
    private func startPaymentHelperWeb(withWebPaymentOption paymentOption: PaymentOption)
    {
        guard let sourceIdentifier = paymentOption.sourceIdentifier else { return }
        
        let source = SourceRequest(identifier: sourceIdentifier)
        
        self.openWebPaymentScreen(for: paymentOption, url: nil, binNumber: nil) {
            
            let loaderContainer: LoadingViewSupport? = WebPaymentViewController.tap_findInHierarchy() ?? WebPaymentPopupViewController.tap_findInHierarchy()
            
            if let nonnullLoadingContainer = loaderContainer {
                
                LoadingView.show(in: nonnullLoadingContainer, animated: true)
            }
            
            let alertDissmissClosure = { self.closeWebPaymentScreen() }
            
            let retryAction: TypeAlias.ArgumentlessClosure = {
                
                self.startPayment(withWebPaymentOption: paymentOption)
            }
            
            self.dataManager.callChargeOrAuthorizeAPI(with:                             source,
                                                      paymentOption:                    paymentOption,
                                                      token:                            nil,
                                                      cardBIN:                          nil,
                                                      saveCard:                         nil,
                                                      loader:                           loaderContainer,
                                                      retryAction:                      retryAction,
                                                      alertDismissButtonClickHandler:   alertDissmissClosure)
        }
    }
    private func startPaymentHelperAsync(withWebPaymentOption paymentOption: PaymentOption)
    {
        guard let sourceIdentifier = paymentOption.sourceIdentifier else { return }
        
        let source = SourceRequest(identifier: sourceIdentifier)
        
        let loaderContainer: LoadingViewSupport? = PaymentContentViewController.tap_findInHierarchy() ?? WebPaymentPopupViewController.tap_findInHierarchy()
        
        if let nonnullLoadingContainer = loaderContainer {
            
            LoadingView.show(in: nonnullLoadingContainer, animated: true)
        }
        let retryAction: TypeAlias.ArgumentlessClosure = {
            
            self.startPayment(withWebPaymentOption: paymentOption)
        }
        
        self.dataManager.callChargeOrAuthorizeAPI(with:                             source,
                                                  paymentOption:                    paymentOption,
                                                  token:                            nil,
                                                  cardBIN:                          nil,
                                                  saveCard:                         nil,
                                                  loader:                           loaderContainer,
                                                  retryAction:                      retryAction,
                                                  alertDismissButtonClickHandler:   nil)
    }
    
    
    private func startPayment(withApplePaymentOption paymentOption: PaymentOption) {
        
         if self.dataManagerInterface.canStartApplePayPurchase()
               {
                   let appleRequest:PKPaymentRequest = self.dataManager.createApplePayRequest()
                   
                   if let applePayController = PKPaymentAuthorizationViewController(paymentRequest: appleRequest)
                   {
                       if let topController:UIViewController = UIApplication.shared.keyWindow!.topViewController(){
                           applePayController.delegate = self
                           topController.present(applePayController, animated: true, completion: nil)
                       }
                   }
               }
    }
}

internal final class CardSavingImplementation<HandlerMode: ProcessMode>: Process.Implementation<HandlerMode> {
	
	// MARK: - Internal -
	// MARK: Methods
	
	internal override func startPayment(with paymentOption: PaymentOptionCellViewModel) {
		
		guard let cardPaymentOption = paymentOption as? CardInputTableViewCellModel, let card = cardPaymentOption.card else { return }
		
		guard let selectedPaymentOption = cardPaymentOption.selectedPaymentOption else { return }
		
		let request = CreateTokenWithCardDataRequest(card: card)
		self.dataManager.callTokenAPI(with: request, paymentOption: selectedPaymentOption, saveCard: true)
	}
	
	internal override func closePayment(with status: PaymentStatus, fadeAnimation: Bool, force: Bool, completion: TypeAlias.ArgumentlessClosure?) {
		
		let localCompletion: TypeAlias.BooleanClosure = { (closed) in
			
			if closed {
				
				self.reportDelegateOnPaymentCompletion(with: status)
			}
			
			completion?()
		}
		
		self.forceClosePayment(withFadeAnimation: fadeAnimation) {
			
			localCompletion(true)
		}
	}
	
	internal override func continueCardSaving(with identifier: String, paymentOption: PaymentOption, binNumber: String?, loader: LoadingViewSupport?, retryAction: @escaping TypeAlias.ArgumentlessClosure, alertDismissButtonClickHandler: TypeAlias.ArgumentlessClosure?) {
		
		APIClient.shared.retrieveObject(with: identifier) { (cardVerification: CardVerification?, error: TapSDKError?) in
			
			loader?.hideLoader()
			
			self.dataManager.handleCardVerificationResponse(cardVerification, error: error, binNumber: binNumber, retryAction: retryAction)
		}
	}
	
	internal override func cardSavingSuccess(with cardVerification: CardVerification) {
		
		let popupAppearanceCompletionClosure: TypeAlias.ArgumentlessClosure = { [weak self] in
			
			self?.closePayment(with: .successfulCardSave(cardVerification), fadeAnimation: true, force: false, completion: nil)
		}
		
		self.showSuccessPopup(with: .tap_empty, completion: popupAppearanceCompletionClosure)
	}
	
	internal override func cardSavingFailure(with cardVerification: CardVerification, error: TapSDKError?) {
		
		let completion: TypeAlias.ArgumentlessClosure = {
			
			self.closePayment(with: .cardSaveFailure(cardVerification, error), fadeAnimation: false, force: false, completion: nil)
		}
		
		self.showFailurePopup(completion)
	}
}

internal final class CardTokenizationImplementation<HandlerMode: ProcessMode>: Process.Implementation<HandlerMode>, PKPaymentAuthorizationViewControllerDelegate {
   
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true) {
            if let session:SessionProtocol = Process.shared.externalSession
            {
                session.delegate?.applePaymentCanceled?(on: session)
            }
            
            //guard let strongSelf = self else { return }
            //self?.dataManager.ale showMissingInformationAlert(with: "Payment Canceled", message: "User did not authorize the payment.")
            //self?.closePayment(with: .cancelled, fadeAnimation: false, force: true, completion: nil)
        }
    }
    
    @available(iOS 11.0, *)
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
        controller.dismiss(animated: true) {[weak self] in
            
            
            guard let applePayTokenRequest:CreateTokenWithApplePayRequest = self?.process.createApplePayTokenizationApiRequest(with: payment.token) else {
                self?.cardTokenizationFailure(with: .init(type: .unknown))
                return
            }
            
            self?.dataManager.callApplePayTokenApi(with: applePayTokenRequest,paymentOption: Process.shared.viewModelsHandlerInterface.selectedPaymentOptionCellViewModel?.paymentOption)
        }
    }
	
	internal override func startPayment(with paymentOption: PaymentOptionCellViewModel) {
		
        // We need to know if we are tokenizing Apple pay or Card
        
        guard paymentOption is ApplePaymentOptionTableViewCellModel || paymentOption is CardInputTableViewCellModel else { return }
        
        // Now tokenize based on the selected option
        
        // The card option
        if let cardPaymentOption = paymentOption as? CardInputTableViewCellModel, let card = cardPaymentOption.card {
            guard let selectedPaymentOption = cardPaymentOption.selectedPaymentOption else { return }
            
            //Added by Floward tech team
            let saveCard = cardPaymentOption.cell?.saveCardSwitch?.isOn ?? false
            
            let request = CreateTokenWithCardDataRequest(card: card)
            self.dataManager.callTokenAPI(with: request, paymentOption: selectedPaymentOption, saveCard: saveCard)
        }else if let _ = paymentOption as? ApplePaymentOptionTableViewCellModel { // the Apple pay option
            if self.dataManagerInterface.canStartApplePayPurchase()
            {
                
                let appleRequest:PKPaymentRequest = self.dataManager.createApplePayRequest()
                if let applePayController = PKPaymentAuthorizationViewController(paymentRequest: appleRequest)
                {
                    if let topController:UIViewController = UIApplication.shared.keyWindow!.topViewController(){
                        applePayController.delegate = self
                        topController.present(applePayController, animated: true, completion: nil)
                    }
                }
            }
        }
        		
		
	}
	
	internal override func closePayment(with status: PaymentStatus, fadeAnimation: Bool, force: Bool, completion: TypeAlias.ArgumentlessClosure?) {
		
		let localCompletion: TypeAlias.BooleanClosure = { (closed) in
			
			if closed {
				
				self.reportDelegateOnPaymentCompletion(with: status)
			}
			
			completion?()
		}
		
		self.forceClosePayment(withFadeAnimation: fadeAnimation) {
			
			localCompletion(true)
		}
	}
	
	internal override func cardTokenizationSuccess(with token: Token, customerRequestedToSaveCard: Bool) {
		
		self.closePayment(with: .successfulCardTokenize(token, customerRequestedToSaveCard), fadeAnimation: false, force: false, completion: nil)
	}
	
	internal override func cardTokenizationFailure(with error: TapSDKError) {
		
		self.closePayment(with: .cardTokenizeFailure(error), fadeAnimation: false, force: false, completion: nil)
	}
}

extension UIWindow {
    func topViewController() -> UIViewController? {
        var top = self.rootViewController
        while true {
            if let presented = top?.presentedViewController {
                top = presented
            } else if let nav = top as? UINavigationController {
                top = nav.visibleViewController
            } else if let tab = top as? UITabBarController {
                top = tab.selectedViewController
            } else {
                break
            }
        }
        return top
    }
}
