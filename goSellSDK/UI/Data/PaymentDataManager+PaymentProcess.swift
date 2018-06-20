//
//  PaymentDataManager+PaymentProcess.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class UIKit.UIScreen.UIScreen

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
        
        let loaderFrame = PaymentContentViewController.findInHierarchy()?.paymentOptionsContainerFrame ?? UIScreen.main.bounds
        let loader = LoadingViewController.show(frame: loaderFrame)
        
        self.continuePaymentWithCurrentCharge(paymentOption, loader: loader)
    }
    
    // MARK: - Private -
    
    private struct PaymentProcessConstants {
        
        fileprivate static let returnURL = URL(string: "goSellSDK://return_url")!
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Methods
    
    private func startPaymentProcess(withWebPaymentOption paymentOption: PaymentOption) {
    
        let source = Source(identifier: paymentOption.sourceIdentifier)
        
        let loaderFrame = PaymentContentViewController.findInHierarchy()?.paymentOptionsContainerFrame ?? UIScreen.main.bounds
        let loader = LoadingViewController.show(frame: loaderFrame)
        
        self.callChargeAPI(with: source, paymentOption: paymentOption, loader: loader)
    }
    
    private func startPaymentProcess(with card: CreateTokenCard, paymentOption: PaymentOption, saveCard: Bool) {
        
        let loader = LoadingViewController.show()
        
        let request = CreateTokenWithCardDataRequest(card: card)
        APIClient.shared.createToken(with: request) { [weak self] (token, error) in
            
            if let nonnullToken = token {
                
                let source = Source(token: nonnullToken)
                self?.callChargeAPI(with: source, paymentOption: paymentOption, saveCard: saveCard, loader: loader)
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
            
            NSLog("Not implemented yet.")
            break
            
        case .inProgress, .cancelled, .failed, .declined, .restricted, .void:
            
            self.paymentFailed()
            
        case .captured:
            
            self.paymentSucceed()
            
        }
    }
    
    private func openPaymentURL(_ url: URL, for paymentOption: PaymentOption) {
        
        self.paymentOptionThatRequiresWebPaymentController = paymentOption
        self.urlToLoadInWebPaymentController = url
        
        PaymentOptionsViewController.findInHierarchy()?.showWebPaymentViewController()
    }
    
    private func continuePaymentWithCurrentCharge(_ paymentOption: PaymentOption, loader: LoadingViewController? = nil) {
        
        guard let chargeIdentifier = self.currentCharge?.identifier else { return }
        
        APIClient.shared.retrieveCharge(with: chargeIdentifier) { [weak self] (charge, error) in
            
            loader?.hide()
            self?.handleChargeResponse(charge, error: error, paymentOption: paymentOption)
        }
    }
    
    private func paymentFailed() {
        
        NSLog("Not implemented yet")
    }
    
    private func paymentSucceed() {
        
        NSLog("Not implemented yet")
    }
    
    private func extraFeeAmount(from extraFees: [ExtraFee], in currency: AmountedCurrency) -> Decimal {
        
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
}
