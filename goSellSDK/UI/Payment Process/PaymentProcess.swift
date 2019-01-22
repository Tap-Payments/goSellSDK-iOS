//
//  PaymentProcess.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	CoreGraphics.CGGeometry.CGRect
import struct	TapAdditionsKit.TypeAlias
import class	UIKit.UIResponder.UIResponder
import class	UIKit.UIScreen.UIScreen

internal final class PaymentProcess {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal private(set) var externalSession: SessionProtocol?
	
	internal private(set) lazy var viewModelsHandler			= ViewModelsHandler(process: self)
	internal private(set) lazy var dataManager					= DataManager(process: self)
	internal private(set) lazy var currencySelectionHandler		= CurrencySelectionHandler(process: self)
	internal private(set) lazy var webPaymentHandler			= WebPaymentHandler(process: self)
	internal private(set) lazy var addressInputHandler			= AddressInputHandler(process: self)
	internal private(set) lazy var cardScannerHandler			= CardScannerHandler(process: self)
	internal private(set) lazy var otpHandler					= OTPHandler(process: self)
	
	internal private(set) lazy var buttonHandler: TapProcessButtonHandler = {
		
		var result: TapProcessButtonHandler
		
		switch self.dataManager.transactionMode {
			
		case .purchase, .authorizeCapture:
			
			result = PayProcessButtonHandler(process: self)
			
		case .cardSaving:
			
			result = SaveProcessButtonHandler(process: self)
		}
		
		return result
	}()
	
	// MARK: Methods
	
	@discardableResult internal func start(_ session: SessionProtocol) -> Bool {
		
		let result = self.dataManager.loadPaymentOptions(for: session)
		
		if result {
			
			self.externalSession = session
		}
		
		return result
	}
	
	internal func closePayment(with status: PaymentStatus, fadeAnimation: Bool, force: Bool, completion: TypeAlias.ArgumentlessClosure?) {
		
		let localCompletion: TypeAlias.BooleanClosure = { (closed) in
			
			if closed {
				
				self.reportDelegateOnPaymentCompletion(with: status)
			}
			
			completion?()
		}
		
		if self.dataManager.isCallingPaymentAPI || self.dataManager.isChargeOrAuthorizeInProgress  {
			
			let alertDecision: TypeAlias.BooleanClosure = { (shouldClose) in
				
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
			
			self.forceClosePayment(withFadeAnimation: fadeAnimation) {
				
				localCompletion(true)
			}
		}
	}
	
	internal func startPayment(with paymentOption: PaymentOptionCellViewModel) {
		
		let amount = self.dataManager.selectedCurrency
		let extraFees = paymentOption.paymentOption?.extraFees ?? []
		let extraFeesAmount = AmountedCurrency(amount.currency, AmountCalculator.extraFeeAmount(from: extraFees, in: amount))
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
	
	internal func showPaymentController() {
		
		let controller = PaymentViewController.instantiate()
		
		controller.tap_showOnSeparateWindow(below: .statusBar) { [unowned controller] (rootController) in
			
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
	
	internal func loadingControllerFrame(coveringHeader: Bool) -> CGRect {
		
		let currentController = ResizablePaymentContainerViewController.tap_findInHierarchy()?.currentContentViewController as? NavigationContentViewController
		
		let topOffset = currentController?.contentTopOffset ?? 0.0
		let screenBounds = UIScreen.main.bounds
		var result = screenBounds
		result.origin.y += topOffset
		result.size.height -= topOffset
		
		return result
	}
	
	internal func paymentOptionsControllerKeyboardLayoutFinished() {
		
		self.viewModelsHandler.scrollToSelectedModel()
	}
	
	internal func showMissingInformationAlert(with title: String, message: String) {
		
		let alert = TapAlertController(title: title, message: message, preferredStyle: .alert)
		let closeAction = TapAlertController.Action(title: "Close", style: .default) { [weak alert] (action) in
			
			alert?.hide()
		}
		
		alert.addAction(closeAction)
		
		alert.show()
	}
	
	internal func openPaymentURL(_ url: URL, for paymentOption: PaymentOption, binNumber: String?) {
		
		self.dataManager.urlToLoadInWebPaymentController = url
		self.openWebPaymentScreen(for: paymentOption, url: url, binNumber: binNumber)
	}
	
	internal func continuePaymentWithCurrentChargeOrAuthorize<T: ChargeProtocol>(with identifier: String, of type: T.Type, paymentOption: PaymentOption, loader: LoadingViewSupport?, retryAction: @escaping TypeAlias.ArgumentlessClosure, alertDismissButtonClickHandler: TypeAlias.ArgumentlessClosure?) {
		
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
	
	internal func openOTPScreen(with phoneNumber: String, for paymentOption: PaymentOption) {
		
		self.dataManager.currentPaymentOption = paymentOption
		self.otpHandler.showOTPScreen(with: phoneNumber)
	}
	
	internal func paymentSuccess(with chargeOrAuthorize: ChargeProtocol) {
		
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
		
		self.showPaymentSuccessPopup(with: receiptNumber, completion: popupAppearanceCompletionClosure)
	}
	
	internal func paymentFailure(with status: ChargeStatus, chargeOrAuthorize: ChargeProtocol, error: TapSDKError?) {
		
		self.showPaymentFailurePopup(with: status) {
			
			if let authorize = chargeOrAuthorize as? Authorize {
				
				self.closePayment(with: .authorizationFailure(authorize, error), fadeAnimation: false, force: false, completion: nil)
			}
			else if let charge = chargeOrAuthorize as? Charge {
				
				self.closePayment(with: .chargeFailure(charge, error), fadeAnimation: false, force: false, completion: nil)
			}
			else {
				
				ErrorActionExecutor.closePayment(with: error, nil)
			}
		}
	}
	
	// MARK: - Private -
	// MARK: Properties
	
	private static var storage: PaymentProcess?
	
	// MARK: Methods
	
	private init() {
		
		KnownStaticallyDestroyableTypes.add(PaymentProcess.self)
	}
	
	private func forceStartPayment(with paymentOption: PaymentOptionCellViewModel) {
		
		if let savedCardPaymentOption = paymentOption as? CardCollectionViewCellModel {
			
			let card = savedCardPaymentOption.card
			let paymentOption = paymentOption.paymentOption ?? self.dataManager.paymentOption(for: card)
			self.startPayment(with: card, paymentOption: paymentOption)
		}
		else if let webPaymentOption = paymentOption as? WebPaymentOptionTableViewCellModel {
			
			self.startPayment(withWebPaymentOption: webPaymentOption.paymentOption)
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
		
		guard let customerIdentifier = self.externalSession?.dataSource?.customer?.identifier, let cardIdentifier = savedCard.identifier else { return }
		
		let card = CreateTokenSavedCard(cardIdentifier: cardIdentifier, customerIdentifier: customerIdentifier)
		let request = CreateTokenWithSavedCardRequest(savedCard: card)
		
		self.dataManager.callTokenAPI(with: request, paymentOption: paymentOption, saveCard: nil)
	}
	
	private func startPaymentProcess(with card: CreateTokenCard, paymentOption: PaymentOption, saveCard: Bool) {
		
		let request = CreateTokenWithCardDataRequest(card: card)
		self.dataManager.callTokenAPI(with: request, paymentOption: paymentOption, saveCard: saveCard)
	}
	
	private func startPayment(withWebPaymentOption paymentOption: PaymentOption) {
		
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
													  cardBIN:                          nil,
													  saveCard:                         nil,
													  loader:                           loaderContainer,
													  retryAction:                      retryAction,
													  alertDismissButtonClickHandler:   alertDissmissClosure)
		}
	}
	
	private func openWebPaymentScreen(for paymentOption: PaymentOption, url: URL?, binNumber: String?, completion: TypeAlias.ArgumentlessClosure? = nil) {
		
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
		}
	}
	
	private func closeWebPaymentScreen() {
		
		if let popupController = WebPaymentPopupViewController.tap_findInHierarchy() {
			
			popupController.hide()
		}
		
		if let pushedController = WebPaymentViewController.tap_findInHierarchy() {
			
			pushedController.navigationController?.popViewController(animated: true)
		}
	}
	
	private func showCancelPaymentAlert(with decision: @escaping TypeAlias.BooleanClosure) {
		
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
	
	private func forceClosePayment(withFadeAnimation: Bool, completion: TypeAlias.ArgumentlessClosure?) {
		
		KnownStaticallyDestroyableTypes.destroyAllDelayedDestroyableInstances {
			
			if let paymentContentController = PaymentContentViewController.tap_findInHierarchy() {
				
				paymentContentController.hide(usingFadeAnimation: withFadeAnimation) {
					
					PaymentProcess.paymentClosed()
					completion?()
				}
			}
			else {
				
				PaymentProcess.paymentClosed()
				completion?()
			}
		}
	}
	
	private func reportDelegateOnPaymentCompletion(with status: PaymentStatus) {
		
		guard let session = self.externalSession, let delegate = session.delegate else { return }
		
		switch status {
			
		case .cancelled:
			
			delegate.sessionCancelled?(session)
			
		case .successfulCharge(let charge):
			
			delegate.paymentSucceed?(charge, on: session)
			
		case .successfulAuthorize(let authorize):
			
			delegate.authorizationSucceed?(authorize, on: session)
			
		case .chargeFailure(let charge, let error):
			
			delegate.paymentFailed?(with: charge, error: error, on: session)
			
		case .authorizationFailure(let authorize, let error):
			
			delegate.authorizationFailed?(with: authorize, error: error, on: session)
			
		case .cardSaveFailure(let error):
			
			delegate.cardSavingFailed?(with: error, on: session)
		}
	}
	
	private func showPaymentFailurePopup(with status: ChargeStatus, completion: @escaping TypeAlias.ArgumentlessClosure) {
		
		let disappearanceTime = (SettingsDataManager.shared.settings?.internalSettings ?? InternalSDKSettings.default).statusDisplayDuration
		
		let popup           = StatusPopupViewController.shared
		popup.titleText     = LocalizationProvider.shared.localizedString(for: .payment_status_alert_failed)
		popup.subtitleText  = nil
		popup.success		= false
		
		popup.display { [weak popup] in
			
			popup?.idleDisappearanceTimeInterval = disappearanceTime
			completion()
		}
	}
	
	private func showPaymentSuccessPopup(with receiptNumber: String, completion: @escaping TypeAlias.ArgumentlessClosure) {
		
		let disappearanceTime = (SettingsDataManager.shared.settings?.internalSettings ?? InternalSDKSettings.default).statusDisplayDuration
		
		let popup           = StatusPopupViewController.shared
		popup.titleText     = LocalizationProvider.shared.localizedString(for: .payment_status_alert_successful)
		popup.subtitleText  = receiptNumber
		popup.success		= true
		
		popup.display { [weak popup] in
			
			popup?.idleDisappearanceTimeInterval = disappearanceTime
			completion()
		}
	}
	
	private static func paymentClosed() {
		
		KnownStaticallyDestroyableTypes.destroyAllInstances()
	}
}

// MARK: - ImmediatelyDestroyable
extension PaymentProcess: ImmediatelyDestroyable {
	
	internal static var hasAliveInstance: Bool {
		
		return self.storage != nil
	}
	
	internal static func destroyInstance() {
		
		self.storage = nil
	}
}

// MARK: - Singleton
extension PaymentProcess: Singleton {
	
	internal static var shared: PaymentProcess {
		
		if let nonnullStorage = self.storage {
			
			return nonnullStorage
		}
		
		let instance = PaymentProcess()
		self.storage = instance
		
		return instance
	}
}
