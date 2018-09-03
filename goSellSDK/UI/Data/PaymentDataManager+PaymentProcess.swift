//
//  PaymentDataManager+PaymentProcess.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct   CoreGraphics.CGGeometry.CGRect
import struct   TapAdditionsKit.TypeAlias
import class    UIKit.UIAlertController.UIAlertAction
import class    UIKit.UIAlertController.UIAlertController
import class    UIKit.UIResponder.UIResponder
import class    UIKit.UIScreen.UIScreen
import var      UIKit.UIWindow.UIWindowLevelStatusBar

internal extension PaymentDataManager {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal func startPaymentProcess(with paymentOption: PaymentOptionCellViewModel) {
        
        let amount = self.userSelectedCurrency ?? self.transactionCurrency
        let extraFees = paymentOption.paymentOption?.extraFees ?? []
        let extraFeesAmount = AmountedCurrency(amount.currency, self.extraFeeAmount(from: extraFees, in: amount))
        if extraFeesAmount.amount > 0.0 {
            
            self.showExtraFeesPaymentAlert(with: amount, extraFeesAmount: extraFeesAmount) { (shouldProcessPayment) in
                
                if shouldProcessPayment {
                    
                    self.forceStartPaymentProcess(with: paymentOption)
                }
                else {
                    
                    self.deselectAllPaymentOptionsModels()
                }
            }
        }
        else {
            
            self.forceStartPaymentProcess(with: paymentOption)
        }
    }
    
    internal func showLoadingController(_ coveringHeader: Bool = false) -> LoadingViewController {
        
        let loaderFrame = self.loadingControllerFrame(coveringHeader: coveringHeader)
        let loader = LoadingViewController.show(topOffset: loaderFrame.minY)
        
        return loader
    }
    
    internal func prepareWebPaymentController(_ controller: WebPaymentViewController) {
        
        guard let paymentOption = self.currentPaymentOption else {
            
            fatalError("This code should never be executed.")
        }
        
        var binInformation: BINResponse? = nil
        if let binNumber = self.currentPaymentCardBINNumber {
        
            binInformation = BINDataManager.shared.cachedBINData(for: binNumber)
        }
        
        controller.setup(with: paymentOption, url: self.urlToLoadInWebPaymentController, binInformation: binInformation)
    }
    
    internal func decision(forWebPayment url: URL) -> WebPaymentURLDecision {
        
        let urlIsReturnURL = url.absoluteString.starts(with: PaymentProcessConstants.returnURL.absoluteString)
        
        let shouldLoad = !urlIsReturnURL
        let redirectionFinished = urlIsReturnURL
        let tapID = url[PaymentProcessConstants.tapIDKey]
        let shouldCloseWebPaymentScreen = redirectionFinished && self.currentPaymentOption?.paymentType == .card

        return WebPaymentURLDecision(shouldLoad: shouldLoad, shouldCloseWebPaymentScreen: shouldCloseWebPaymentScreen, redirectionFinished: redirectionFinished, tapID: tapID)
    }
    
    internal func webPaymentProcessFinished(_ chargeOrAuthorizeID: String) {
        
        guard let paymentOption = self.currentPaymentOption, let chargeOrAuthorize = self.currentChargeOrAuthorize else { return }
        
        let loader = self.showLoadingController()
        let retryAction: TypeAlias.ArgumentlessClosure = { [weak self] in
            
            self?.webPaymentProcessFinished(chargeOrAuthorizeID)
        }
        
        if chargeOrAuthorize is Charge {

            self.continuePaymentWithCurrentChargeOrAuthorize(with: chargeOrAuthorizeID, of: Charge.self, paymentOption: paymentOption, loader: loader, retryAction: retryAction, alertDismissButtonClickHandler: nil)
        }
        else if chargeOrAuthorize is Authorize {

            self.continuePaymentWithCurrentChargeOrAuthorize(with: chargeOrAuthorizeID, of: Authorize.self, paymentOption: paymentOption, loader: loader, retryAction: retryAction, alertDismissButtonClickHandler: nil)
        }
    }
    
    internal func extraFeeAmount(from extraFees: [ExtraFee], in currency: AmountedCurrency) -> Decimal {
        
        var result: Decimal = 0.0
        
        extraFees.forEach { fee in
            
            switch fee.type {
                
            case .fixedAmount:
                
                if let feeAmountedCurrency = self.supportedCurrencies.first(where: { $0.currency == fee.currency }) {
                    
                    result += currency.amount * fee.value / feeAmountedCurrency.amount
                }
                else {
                    
                    fatalError("Currency \(fee.currency) is not a supported currency!")
                }
                
            case .percents:
                
                result += currency.amount * fee.normalizedValue
            }
        }
        
        return result
    }
    
    internal func handleChargeOrAuthorizeResponse<T: ChargeProtocol>(_ chargeOrAuthorize: T?, error: TapSDKError?, retryAction: @escaping TypeAlias.ArgumentlessClosure) {
        
        guard let paymentOption = self.currentPaymentOption else { return }
        
        self.handleChargeOrAuthorizeResponse(chargeOrAuthorize, error: error, paymentOption: paymentOption, cardBIN: self.currentPaymentCardBINNumber, retryAction: retryAction, alertDismissButtonClickHandler: nil)
    }
    
    internal func paymentCancelled() {
        
        self.lastSelectedPaymentOption          = nil
        self.currentPaymentOption               = nil
        self.currentPaymentCardBINNumber        = nil
        self.urlToLoadInWebPaymentController    = nil
        self.currentChargeOrAuthorize           = nil
    }
    
    // MARK: - Private -
    
    private struct PaymentProcessConstants {
        
        fileprivate static let returnURL = URL(string: "gosellsdk://return_url")!
        fileprivate static let tapIDKey = "tap_id"
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
    
    private var chargeRequires3DSecure: Bool {
        
        if let permissions = SettingsDataManager.shared.settings?.permissions {
            
            return !permissions.contains(.non3DSecureTransactions)
        }
        else {
            
            return true
        }
    }
    
    // MARK: Methods
    
    private func showExtraFeesPaymentAlert(with plainAmount: AmountedCurrency, extraFeesAmount: AmountedCurrency, decision: @escaping TypeAlias.BooleanClosure) {
        
        UIResponder.resign {
            
            let totalAmount = AmountedCurrency(plainAmount.currency, plainAmount.amount + extraFeesAmount.amount, plainAmount.currencySymbol)
            
            let extraFeesAmountText = CurrencyFormatter.shared.format(extraFeesAmount)
            let totalAmountText = CurrencyFormatter.shared.format(totalAmount)
            
            let title = "Confirm extra charges"
            let message = "You will be charged an additional fee of \(extraFeesAmountText) for this type of payment, totaling an amount of \(totalAmountText)"
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { [weak alert] (action) in
                
                alert?.dismissFromSeparateWindow(true, completion: nil)
                decision(false)
            }
            
            let confirmAction: UIAlertAction = UIAlertAction(title: "Confirm", style: .default) { [weak alert] (action) in
                
                alert?.dismissFromSeparateWindow(true, completion: nil)
                decision(true)
            }
            
            alert.addAction(cancelAction)
            alert.addAction(confirmAction)
            
            DispatchQueue.main.async {
                
                alert.showOnSeparateWindow(true, below: UIWindowLevelStatusBar, completion: nil)
            }
        }
    }
    
    private func forceStartPaymentProcess(with paymentOption: PaymentOptionCellViewModel) {
        
        if let savedCardPaymentOption = paymentOption as? CardCollectionViewCellModel {
            
            let card = savedCardPaymentOption.card
            let paymentOption = paymentOption.paymentOption ?? self.paymentOption(for: card)
            self.startPaymentProcess(with: card, paymentOption: paymentOption)
        }
        else if let webPaymentOption = paymentOption as? WebPaymentOptionTableViewCellModel {
            
            self.startPaymentProcess(withWebPaymentOption: webPaymentOption.paymentOption)
        }
        else if let cardPaymentOption = paymentOption as? CardInputTableViewCellModel, let card = cardPaymentOption.card {
            
            guard let selectedPaymentOption = cardPaymentOption.selectedPaymentOption else {
                
                fatalError("Selected payment option is not defined.")
            }
            
            self.startPaymentProcess(with: card, paymentOption: selectedPaymentOption, saveCard: cardPaymentOption.shouldSaveCard)
        }
    }
    
    private func loadingControllerFrame(coveringHeader: Bool = false) -> CGRect {
        
        let topOffset = PaymentContentViewController.findInHierarchy()?.paymentOptionsContainerTopOffset ?? 0.0
        let screenBounds = UIScreen.main.bounds
        var result = screenBounds
        result.origin.y += topOffset
        result.size.height -= topOffset
        
        return result
    }
    
    private func paymentOption(for savedCard: SavedCard) -> PaymentOption {
        
        let options = self.paymentOptions.filter { $0.identifier == savedCard.paymentOptionIdentifier }
        guard let firstAndOnlyOption = options.first, options.count == 1 else {
            
            fatalError("Cannot uniqely identify payment option.")
        }
        
        return firstAndOnlyOption
    }
    
    private func startPaymentProcess(with savedCard: SavedCard, paymentOption: PaymentOption) {
        
        guard let customerIdentifier = self.externalDataSource?.customer?.identifier, let cardIdentifier = savedCard.identifier else { return }
        
        let card = CreateTokenSavedCard(cardIdentifier: cardIdentifier, customerIdentifier: customerIdentifier)
        let request = CreateTokenWithSavedCardRequest(savedCard: card)
        
        self.callTokenAPI(with: request, paymentOption: paymentOption)
    }
    
    private func startPaymentProcess(with card: CreateTokenCard, paymentOption: PaymentOption, saveCard: Bool) {
        
        let request = CreateTokenWithCardDataRequest(card: card)
        self.callTokenAPI(with: request, paymentOption: paymentOption, saveCard: saveCard)
    }
    
    private func callTokenAPI(with request: CreateTokenRequest, paymentOption: PaymentOption, saveCard: Bool? = nil) {
        
        UIResponder.current?.resignFirstResponder()
        
        self.isExecutingAPICalls = true
        self.payButtonUI?.startLoader()
        
        APIClient.shared.createToken(with: request) { [weak self] (token, error) in
            
            if let nonnullError = error {
                
                self?.payButtonUI?.stopLoader()
                self?.isExecutingAPICalls = false
                
                ErrorDataManager.handle(nonnullError, retryAction: { self?.callTokenAPI(with: request, paymentOption: paymentOption, saveCard: saveCard) }, alertDismissButtonClickHandler: nil)
            }
            else if let nonnullToken = token {
                
                let source = SourceRequest(token: nonnullToken)
                self?.callChargeOrAuthorizeAPI(with: source, paymentOption: paymentOption, cardBIN: nonnullToken.card.binNumber, saveCard: saveCard, retryAction: { self?.callTokenAPI(with: request, paymentOption: paymentOption, saveCard: saveCard) }, alertDismissButtonClickHandler: nil)
            }
            else {
                
                self?.payButtonUI?.stopLoader()
                self?.isExecutingAPICalls = false
            }
        }
    }
    
    private func startPaymentProcess(withWebPaymentOption paymentOption: PaymentOption) {
    
        let source = SourceRequest(identifier: paymentOption.sourceIdentifier)
        
        self.openWebPaymentScreen(for: paymentOption)
        
        self.isExecutingAPICalls = true
        let loader = self.showLoadingController()
        
        let alertDissmissClosure = { self.closeWebPaymentScreen() }
        
        self.callChargeOrAuthorizeAPI(with: source, paymentOption: paymentOption, loader: loader, retryAction: { self.startPaymentProcess(withWebPaymentOption: paymentOption) }, alertDismissButtonClickHandler: alertDissmissClosure)
    }
    
    private func callChargeOrAuthorizeAPI(with source: SourceRequest, paymentOption: PaymentOption, cardBIN: String? = nil, saveCard: Bool? = nil, loader: LoadingViewController? = nil, retryAction: @escaping TypeAlias.ArgumentlessClosure, alertDismissButtonClickHandler: TypeAlias.ArgumentlessClosure?) {
        
        guard
            
            let customer    = self.externalDataSource?.customer,
            let orderID     = self.orderIdentifier else {
                
                fatalError("This case should never happen.")
        }
        
        var post: TrackingURL? = nil
        if let postURL = self.externalDataSource?.postURL, let nonnullPostURL = postURL {
            
            post = TrackingURL(url: nonnullPostURL)
        }
        
        let amountedCurrency    = self.userSelectedCurrency ?? self.transactionCurrency
        let fee                 = self.extraFeeAmount(from: paymentOption.extraFees, in: amountedCurrency)
        let order               = Order(identifier: orderID)
        let redirect            = TrackingURL(url: PaymentProcessConstants.returnURL)
        let paymentDescription  = self.externalDataSource?.paymentDescription ?? nil
        let paymentMetadata     = self.externalDataSource?.paymentMetadata ?? nil
        let reference           = self.externalDataSource?.paymentReference ?? nil
        let shouldSaveCard      = saveCard ?? false
        let statementDescriptor = self.externalDataSource?.paymentStatementDescriptor ?? nil
        let receiptSettings     = self.externalDataSource?.receiptSettings ?? nil
        
        let requires3DSecure    = self.chargeRequires3DSecure || (self.externalDataSource?.require3DSecure ?? false)
        
        let mode = self.externalDataSource?.mode ?? .purchase
        switch mode {
            
        case .purchase:
            
            let chargeRequest = CreateChargeRequest(amount:                 amountedCurrency.amount,
                                                    currency:               amountedCurrency.currency,
                                                    customer:               customer,
                                                    fee:                    fee,
                                                    order:                  order,
                                                    redirect:               redirect,
                                                    post:                   post,
                                                    source:                 source,
                                                    descriptionText:        paymentDescription,
                                                    metadata:               paymentMetadata,
                                                    reference:              reference,
                                                    shouldSaveCard:         shouldSaveCard,
                                                    statementDescriptor:    statementDescriptor,
                                                    requires3DSecure:       requires3DSecure,
                                                    receipt:                receiptSettings)
            
            APIClient.shared.createCharge(with: chargeRequest) { [weak self] (charge, error) in
                
                loader?.hide(animated: true, async: true, fromDestroyInstance: false)
                self?.payButtonUI?.stopLoader()
                self?.isExecutingAPICalls = false
                
                self?.handleChargeOrAuthorizeResponse(charge, error: error, paymentOption: paymentOption, cardBIN: cardBIN, retryAction: retryAction, alertDismissButtonClickHandler: alertDismissButtonClickHandler)
            }
            
        case .authorizeCapture:
            
            let authorizeAction = self.externalDataSource?.authorizeAction ?? .default
            
            let authorizeRequest = CreateAuthorizeRequest(amount:                 amountedCurrency.amount,
                                                          currency:               amountedCurrency.currency,
                                                          customer:               customer,
                                                          fee:                    fee,
                                                          order:                  order,
                                                          redirect:               redirect,
                                                          post:                   post,
                                                          source:                 source,
                                                          descriptionText:        paymentDescription,
                                                          metadata:               paymentMetadata,
                                                          reference:              reference,
                                                          shouldSaveCard:         shouldSaveCard,
                                                          statementDescriptor:    statementDescriptor,
                                                          requires3DSecure:       requires3DSecure,
                                                          receipt:                receiptSettings,
                                                          authorizeAction:        authorizeAction)
            
            APIClient.shared.createAuthorize(with: authorizeRequest) { [weak self] (authorize, error) in
                
                loader?.hide(animated: true, async: true, fromDestroyInstance: false)
                self?.payButtonUI?.stopLoader()
                self?.isExecutingAPICalls = false
                
                self?.handleChargeOrAuthorizeResponse(authorize, error: error, paymentOption: paymentOption, cardBIN: cardBIN, retryAction: retryAction, alertDismissButtonClickHandler: alertDismissButtonClickHandler)
            }
        }
    }
    
    private func handleChargeOrAuthorizeResponse<T: ChargeProtocol>(_ chargeOrAuthorize: T?, error: TapSDKError?, paymentOption: PaymentOption, cardBIN: String? = nil, retryAction: @escaping TypeAlias.ArgumentlessClosure, alertDismissButtonClickHandler: TypeAlias.ArgumentlessClosure?) {
        
        if let nonnullError = error {
            
            ErrorDataManager.handle(nonnullError, retryAction: retryAction, alertDismissButtonClickHandler: alertDismissButtonClickHandler)
            return
        }
        
        guard let nonnullChargeOrAuthorize = chargeOrAuthorize else { return }
        
        self.currentChargeOrAuthorize = nonnullChargeOrAuthorize
        
        switch nonnullChargeOrAuthorize.status {
            
        case .initiated:
            
            if let authentication = nonnullChargeOrAuthorize.authentication, authentication.status == .initiated {
                
                switch authentication.type {
                    
                case .biometrics:
                    
                    break
                    
                case .otp:
                    
                    self.openOTPScreen(with: authentication.value, for: paymentOption)
                }
            }
            else if let url = nonnullChargeOrAuthorize.transactionDetails.url {
                
                self.openPaymentURL(url, for: paymentOption, binNumber: cardBIN)
            }
            
        case .inProgress, .abandoned, .cancelled, .failed, .declined, .restricted, .void:
            
            self.paymentFailure(with: nonnullChargeOrAuthorize.status, chargeOrAuthorize: nonnullChargeOrAuthorize, error: error)
            
        case .captured, .authorized:
            
            self.paymentSuccess(with: nonnullChargeOrAuthorize)
        }
    }
    
    private func openPaymentURL(_ url: URL, for paymentOption: PaymentOption, binNumber: String? = nil) {
        
        self.urlToLoadInWebPaymentController = url
        self.openWebPaymentScreen(for: paymentOption, url: url, binNumber: binNumber)
    }
    
    private func openWebPaymentScreen(for paymentOption: PaymentOption, url: URL? = nil, binNumber: String? = nil) {
        
        self.currentPaymentOption = paymentOption
        self.currentPaymentCardBINNumber = binNumber
        
        switch paymentOption.paymentType {
            
        case .card:
            
            guard let nonnullURL = url else { return }
            
            let webPopupControllerFrame = self.loadingControllerFrame()
            
            WebPaymentPopupViewController.show(with: webPopupControllerFrame.minY, with: nonnullURL)
            
        case .web:
            
            if let alreadyOpenedWebPaymentController = WebPaymentViewController.findInHierarchy() {
                
                self.prepareWebPaymentController(alreadyOpenedWebPaymentController)
            }
            else {
                
                PaymentOptionsViewController.findInHierarchy()?.showWebPaymentViewController()
            }
        }
    }
    
    private func closeWebPaymentScreen() {
        
        if let popupController = WebPaymentPopupViewController.findInHierarchy() {
            
            popupController.hide()
        }
        
        if let pushedController = WebPaymentViewController.findInHierarchy() {
            
            pushedController.navigationController?.popViewController(animated: true)
        }
    }
    
    private func openOTPScreen(with phoneNumber: String, for paymentOption: PaymentOption) {
        
        self.currentPaymentOption = paymentOption
        
        let otpControllerFrame = self.loadingControllerFrame()
        OTPViewController.show(with: otpControllerFrame.minY, with: phoneNumber, delegate: self)
    }
    
    private func continuePaymentWithCurrentChargeOrAuthorize<T: ChargeProtocol>(with identifier: String, of type: T.Type, paymentOption: PaymentOption, loader: LoadingViewController? = nil, retryAction: @escaping TypeAlias.ArgumentlessClosure, alertDismissButtonClickHandler: TypeAlias.ArgumentlessClosure?) {
        
        APIClient.shared.retrieveObject(with: identifier) { (returnChargeOrAuthorize: T?, error: TapSDKError?) in
            
            loader?.hide(animated: true, async: true, fromDestroyInstance: false)
            self.handleChargeOrAuthorizeResponse(returnChargeOrAuthorize, error: error, paymentOption: paymentOption, retryAction: retryAction, alertDismissButtonClickHandler: alertDismissButtonClickHandler)
        }
    }
    
    private func paymentSuccess(with chargeOrAuthorize: ChargeProtocol) {
        
        let popupAppearanceCompletionClosure: TypeAlias.ArgumentlessClosure = { [weak self] in
            
            if let authorize = chargeOrAuthorize as? Authorize {
                
                self?.closePayment(with: .successfulAuthorize(authorize), fadeAnimation: true)
            }
            else if let charge = chargeOrAuthorize as? Charge {
                
                self?.closePayment(with: .successfulCharge(charge), fadeAnimation: true)
            }
        }
        
        guard let receiptNumber = chargeOrAuthorize.receiptSettings?.identifier else {
            
            popupAppearanceCompletionClosure()
            return
        }
        
        self.showPaymentSuccessPopup(with: receiptNumber, completion: popupAppearanceCompletionClosure)
    }
    
    private func paymentFailure(with status: ChargeStatus, chargeOrAuthorize: ChargeProtocol, error: TapSDKError?) {
        
        self.showPaymentFailurePopup(with: status) {
            
            if let authorize = chargeOrAuthorize as? Authorize {
                
                self.closePayment(with: .authorizationFailure(authorize, error))
            }
            else if let charge = chargeOrAuthorize as? Charge {
                
                self.closePayment(with: .chargeFailure(charge, error))
            }
            else {
                
                let mode = self.externalDataSource?.mode ?? .purchase
                switch mode {
                    
                case .purchase:         self.closePayment(with: .chargeFailure(nil, error))
                case .authorizeCapture: self.closePayment(with: .authorizationFailure(nil, error))
                
                }
            }
        }
    }
    
    private func showPaymentFailurePopup(with status: ChargeStatus, completion: @escaping TypeAlias.ArgumentlessClosure) {
        
        let disappearanceTime = (SettingsDataManager.shared.settings?.internalSettings ?? InternalSDKSettings.default).statusDisplayDuration
        
        let popup           = StatusPopupViewController.shared
        popup.titleText     = status.localizedDescription
        popup.subtitleText  = nil
        popup.iconImage     = .named("ic_x_red", in: .goSellSDKResources)
        
        popup.display { [weak popup] in
            
            popup?.idleDisappearanceTimeInterval = disappearanceTime
            completion()
        }
    }
    
    private func showPaymentSuccessPopup(with receiptNumber: String, completion: @escaping TypeAlias.ArgumentlessClosure) {
        
        let disappearanceTime = (SettingsDataManager.shared.settings?.internalSettings ?? InternalSDKSettings.default).statusDisplayDuration
        
        let popup           = StatusPopupViewController.shared
        popup.titleText     = "Successful"
        popup.subtitleText  = receiptNumber
        popup.iconImage     = .named("ic_checkmark_green", in: .goSellSDKResources)
        
        popup.display { [weak popup] in
            
            popup?.idleDisappearanceTimeInterval = disappearanceTime
            completion()
        }
    }
}
