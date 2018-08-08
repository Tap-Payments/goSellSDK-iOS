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
        let extraFeesAmount = AmountedCurrency(amount.currency, self.extraFeeAmount(from: paymentOption.paymentOption?.extraFees ?? [], in: amount))
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
        
        let shouldLoad = url != PaymentProcessConstants.returnURL
        let redirectionFinished = url == PaymentProcessConstants.returnURL
        let shouldCloseWebPaymentScreen = redirectionFinished && self.currentPaymentOption?.paymentType == .card
        
        return WebPaymentURLDecision(shouldLoad: shouldLoad, shouldCloseWebPaymentScreen: shouldCloseWebPaymentScreen, redirectionFinished: redirectionFinished)
    }
    
    internal func webPaymentProcessFinished() {
        
        guard let paymentOption = self.currentPaymentOption else { return }
        
        let loader = self.showLoadingController()
        
        self.continuePaymentWithCurrentCharge(paymentOption, loader: loader) {
            
            self.webPaymentProcessFinished()
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
    
    internal func handleChargeResponse(_ charge: Charge?, error: TapSDKError?, retryAction: @escaping TypeAlias.ArgumentlessClosure) {
        
        guard let paymentOption = self.currentPaymentOption else { return }
        
        self.handleChargeResponse(charge, error: error, paymentOption: paymentOption, cardBIN: self.currentPaymentCardBINNumber, retryAction: retryAction)
    }
    
    internal func paymentCancelled() {
        
        self.lastSelectedPaymentOption          = nil
        self.currentPaymentOption               = nil
        self.currentPaymentCardBINNumber        = nil
        self.urlToLoadInWebPaymentController    = nil
        self.currentCharge                      = nil
    }
    
    // MARK: - Private -
    
    private struct PaymentProcessConstants {
        
        fileprivate static let returnURL = URL(string: "gosellsdk://return_url")!
        
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
            let paymentOption = self.paymentOption(for: card)
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
        
        let options = self.paymentOptions.filter { $0.supportedCardBrands.contains(savedCard.brand) }
        guard let firstAndOnlyOption = options.first, options.count == 1 else {
            
            fatalError("Cannot uniqely identify payment option.")
        }
        
        return firstAndOnlyOption
    }
    
    private func startPaymentProcess(with savedCard: SavedCard, paymentOption: PaymentOption) {
        
        guard let cardIdentifier = savedCard.identifier, let customerIdentifier = self.externalDataSource?.customer?.identifier else { return }
        
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
                
                ErrorDataManager.handle(nonnullError) {
                    
                    self?.callTokenAPI(with: request, paymentOption: paymentOption, saveCard: saveCard)
                }
            }
            else if let nonnullToken = token {
                
                let source = Source(token: nonnullToken)
                self?.callChargeAPI(with: source, paymentOption: paymentOption, cardBIN: nonnullToken.card.binNumber, saveCard: saveCard) {
                    
                    self?.callTokenAPI(with: request, paymentOption: paymentOption, saveCard: saveCard)
                }
            }
            else {
                
                self?.payButtonUI?.stopLoader()
                self?.isExecutingAPICalls = false
            }
        }
    }
    
    private func startPaymentProcess(withWebPaymentOption paymentOption: PaymentOption) {
    
        let source = Source(identifier: paymentOption.sourceIdentifier)
        
        self.openWebPaymentScreen(for: paymentOption)
        
        self.isExecutingAPICalls = true
        let loader = self.showLoadingController()
        
        self.callChargeAPI(with: source, paymentOption: paymentOption, loader: loader) {
            
            self.startPaymentProcess(withWebPaymentOption: paymentOption)
        }
    }
    
    private func callChargeAPI(with source: Source, paymentOption: PaymentOption, cardBIN: String? = nil, saveCard: Bool? = nil, loader: LoadingViewController? = nil, retryAction: @escaping TypeAlias.ArgumentlessClosure) {
        
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
            
            loader?.hide()
            self?.payButtonUI?.stopLoader()
            self?.isExecutingAPICalls = false
            
            self?.handleChargeResponse(charge, error: error, paymentOption: paymentOption, cardBIN: cardBIN, retryAction: retryAction)
        }
    }
    
    private func handleChargeResponse(_ charge: Charge?, error: TapSDKError?, paymentOption: PaymentOption, cardBIN: String? = nil, retryAction: @escaping TypeAlias.ArgumentlessClosure) {
        
        if let nonnullError = error {
            
            ErrorDataManager.handle(nonnullError, retryAction: retryAction)
            return
        }
        
        guard let nonnullCharge = charge else { return }
        
        self.currentCharge = nonnullCharge
        
        switch nonnullCharge.status {
            
        case .initiated:
            
            if let authentication = nonnullCharge.authentication, authentication.status == .initiated {
                
                switch authentication.type {
                    
                case .biometrics:
                    
                    break
                    
                case .otp:
                    
                    self.openOTPScreen(with: authentication.value, for: paymentOption)
                }
            }
            else if let url = nonnullCharge.transactionDetails.url {
                
                self.openPaymentURL(url, for: paymentOption, binNumber: cardBIN)
            }
            
        case .inProgress, .abandoned, .cancelled, .failed, .declined, .restricted, .void:
            
            self.paymentFailure(with: nonnullCharge.status)
            
        case .captured:
            
            if let receiptNumber = nonnullCharge.receiptSettings?.identifier, let customerID = nonnullCharge.customer.identifier {
                
                self.paymentSuccess(with: receiptNumber, customerID: customerID)
            }
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
    
    private func openOTPScreen(with phoneNumber: String, for paymentOption: PaymentOption) {
        
        self.currentPaymentOption = paymentOption
        
        let otpControllerFrame = self.loadingControllerFrame()
        OTPViewController.show(with: otpControllerFrame.minY, with: phoneNumber, delegate: self)
    }
    
    private func continuePaymentWithCurrentCharge(_ paymentOption: PaymentOption, loader: LoadingViewController? = nil, retryAction: @escaping TypeAlias.ArgumentlessClosure) {
        
        guard let chargeIdentifier = self.currentCharge?.identifier else { return }
        
        APIClient.shared.retrieveCharge(with: chargeIdentifier) { [weak self] (charge, error) in
            
            loader?.hide()
            self?.handleChargeResponse(charge, error: error, paymentOption: paymentOption, retryAction: retryAction)
        }
    }
    
    private func paymentSuccess(with receiptNumber: String, customerID: String) {
        
        self.showPaymentSuccessPopup(with: receiptNumber) {
            
            self.closePayment(with: .success(customerID), fadeAnimation: true)
        }
    }
    
    private func paymentFailure(with status: ChargeStatus) {
        
        self.showPaymentFailurePopup(with: status) {
            
            self.closePayment(with: .failure, fadeAnimation: true)
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
