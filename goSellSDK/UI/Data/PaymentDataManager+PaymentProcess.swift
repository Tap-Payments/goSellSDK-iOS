//
//  PaymentDataManager+PaymentProcess.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct   CoreGraphics.CGGeometry.CGRect
import class    UIKit.UIScreen.UIScreen

internal extension PaymentDataManager {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal func startPaymentProcess(with paymentOption: PaymentOptionCellViewModel) {
        
        if let webPaymentOption = paymentOption as? WebPaymentOptionTableViewCellModel {
            
            self.startPaymentProcess(withWebPaymentOption: webPaymentOption.paymentOption)
        }
        else if let cardPaymentOption = paymentOption as? CardInputTableViewCellModel, let card = cardPaymentOption.card {

            guard let selectedPaymentOption = cardPaymentOption.selectedPaymentOption else {
                
                fatalError("Selected payment option is not defined.")
            }
            
            self.startPaymentProcess(with: card, paymentOption: selectedPaymentOption, saveCard: cardPaymentOption.shouldSaveCard)
        }
    }
    
    internal func prepareWebPaymentController(_ controller: WebPaymentViewController) {
        
        guard let url = self.urlToLoadInWebPaymentController, let paymentOption = self.paymentOptionThatRequiresWebPaymentController else {
            
            fatalError("This code should never be executed.")
        }
        
        controller.setup(with: paymentOption, url: url)
    }
    
    internal func decision(forWebPayment url: URL) -> WebPaymentURLDecision {
        
        let shouldLoad = url != PaymentProcessConstants.returnURL
        let shouldClosePaymentScreen = url == PaymentProcessConstants.returnURL
        
        return WebPaymentURLDecision(shouldLoad: shouldLoad, shouldCloseWebPaymentScreen: shouldClosePaymentScreen)
    }
    
    internal func webPaymentProcessFinished() {
        
        guard let paymentOption = self.paymentOptionThatRequiresWebPaymentController else { return }
        
        let loaderFrame = self.loadingControllerFrame()
        let loader = LoadingViewController.show(in: loaderFrame)
        
        self.continuePaymentWithCurrentCharge(paymentOption, loader: loader)
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
                
            case .percentBased:
                
                result += currency.amount * fee.normalizedValue
            }
        }
        
        return result
    }
    
    // MARK: - Private -
    
    private struct PaymentProcessConstants {
        
        fileprivate static let returnURL = URL(string: "gosellsdk://return_url")!
        
        @available(*, unavailable) private init() {}
    }
    // MARK: Properties
    
    private func loadingControllerFrame(coveringHeader: Bool = false) -> CGRect {
    
        let topOffset = PaymentContentViewController.findInHierarchy()?.paymentOptionsContainerTopOffset ?? 0.0
        let screenBounds = UIScreen.main.bounds
        var result = screenBounds
        result.origin.y += topOffset
        result.size.height -= topOffset
        
        return result
    }
    
    // MARK: Methods
    
    private func startPaymentProcess(withWebPaymentOption paymentOption: PaymentOption) {
    
        let source = Source(identifier: paymentOption.sourceIdentifier)
        
        self.isExecutingAPICalls = true
        
        let loaderFrame = self.loadingControllerFrame()
        let loader = LoadingViewController.show(in: loaderFrame)
        
        self.callChargeAPI(with: source, paymentOption: paymentOption, loader: loader)
    }
    
    private func startPaymentProcess(with card: CreateTokenCard, paymentOption: PaymentOption, saveCard: Bool) {
        
        UIResponder.current?.resignFirstResponder()
        
        self.isExecutingAPICalls = true
        
        self.payButtonUI?.startLoader()
        
        let request = CreateTokenWithCardDataRequest(card: card)
        APIClient.shared.createToken(with: request) { [weak self] (token, error) in
            
            if let nonnullToken = token {
                
                let source = Source(token: nonnullToken)
                self?.callChargeAPI(with: source, paymentOption: paymentOption, saveCard: saveCard)
            }
            else {
                
                self?.payButtonUI?.stopLoader()
                
                self?.isExecutingAPICalls = false
            }
        }
    }
    
    private func callChargeAPI(with source: Source, paymentOption: PaymentOption, saveCard: Bool? = nil, loader: LoadingViewController? = nil) {
        
        guard
            
            let customer    = self.externalDataSource?.customer,
            let orderID     = self.orderIdentifier else {
                
                fatalError("This case should never happen.")
        }
        
        let amountedCurrency    = self.userSelectedCurrency ?? self.transactionCurrency
        let fee                 = self.extraFeeAmount(from: paymentOption.extraFees, in: amountedCurrency)
        let order               = Order(identifier: orderID)
        let redirect            = Redirect(returnURL: PaymentProcessConstants.returnURL, postURL: self.externalDataSource?.postURL ?? nil)
        let paymentDescription  = self.externalDataSource?.paymentDescription ?? nil
        let paymentMetadata     = self.externalDataSource?.paymentMetadata ?? nil
        let reference           = self.externalDataSource?.paymentReference ?? nil
        let shouldSaveCard      = saveCard ?? false
        let statementDescriptor = self.externalDataSource?.paymentStatementDescriptor ?? nil
        let requires3DSecure    = self.externalDataSource?.require3DSecure ?? false
        let receiptSettings     = self.externalDataSource?.receiptSettings ?? nil
        
        let chargeRequest = CreateChargeRequest(amount:                 amountedCurrency.amount,
                                                currency:               amountedCurrency.currency,
                                                customer:               customer,
                                                fee:                    fee,
                                                order:                  order,
                                                redirect:               redirect,
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
            
            self?.handleChargeResponse(charge, error: error, paymentOption: paymentOption)
        }
    }
    
    private func handleChargeResponse(_ charge: Charge?, error: TapSDKError?, paymentOption: PaymentOption) {
        
        guard let nonnullCharge = charge, error == nil else {
            
            return
        }
        
        self.currentCharge = nonnullCharge
        
        switch nonnullCharge.status {
            
        case .initiated:
            
            guard let url = nonnullCharge.redirect.paymentURL else {
                
                return
            }
            
            self.openPaymentURL(url, for: paymentOption)
            
        case .otpRequired:
            
            self.openOTPScreen()
            
        case .inProgress, .cancelled, .failed, .declined, .restricted, .void:
            
            self.paymentFailed(with: nonnullCharge.status)
            
        case .captured:
            
            if let receiptNumber = charge?.receiptSettings?.identifier {
                
                self.paymentSucceed(with: receiptNumber)
            }
        }
    }
    
    private func openPaymentURL(_ url: URL, for paymentOption: PaymentOption) {
        
        self.paymentOptionThatRequiresWebPaymentController = paymentOption
        self.urlToLoadInWebPaymentController = url
        
        PaymentOptionsViewController.findInHierarchy()?.showWebPaymentViewController()
    }
    
    private func openOTPScreen() {
        
        let otpControllerFrame = self.loadingControllerFrame()
        OTPViewController.show(in: otpControllerFrame)
    }
    
    private func continuePaymentWithCurrentCharge(_ paymentOption: PaymentOption, loader: LoadingViewController? = nil) {
        
        guard let chargeIdentifier = self.currentCharge?.identifier else { return }
        
        APIClient.shared.retrieveCharge(with: chargeIdentifier) { [weak self] (charge, error) in
            
            loader?.hide()
            self?.handleChargeResponse(charge, error: error, paymentOption: paymentOption)
        }
    }
    
    private func paymentFailed(with status: ChargeStatus) {
        
        let disappearanceTime = SettingsDataManager.shared.settings?.internalSettings.statusDisplayDuration
        
        PaymentContentViewController.findInHierarchy()?.hide {
            
            let popup = StatusPopupViewController.instantiate()
            popup.titleText     = status.localizedDescription
            popup.subtitleText  = nil
            popup.iconImage     = .named("ic_x_red", in: .goSellSDKResources)
            
            popup.display { [weak popup] in
                
                if let nonnullDisappearanceTime = disappearanceTime {
                    
                    popup?.idleDisappearanceTimeInterval = nonnullDisappearanceTime
                }
            }
        }
    }
    
    private func paymentSucceed(with receiptNumber: String) {
        
        let disappearanceTime = SettingsDataManager.shared.settings?.internalSettings.statusDisplayDuration
        
        PaymentContentViewController.findInHierarchy()?.hide {
            
            let popup = StatusPopupViewController.instantiate()
            popup.titleText     = "Successful"
            popup.subtitleText  = receiptNumber
            popup.iconImage     = .named("ic_checkmark_green", in: .goSellSDKResources)
            
            popup.display { [weak popup] in
                
                if let nonnullDisappearanceTime = disappearanceTime {
                    
                    popup?.idleDisappearanceTimeInterval = nonnullDisappearanceTime
                }
            }
        }
    }
}
