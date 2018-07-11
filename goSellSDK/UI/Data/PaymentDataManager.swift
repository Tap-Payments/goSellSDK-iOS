//
//  PaymentDataManager.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct TapAdditionsKit.TypeAlias
import enum TapCardValidator.CardBrand

/// Payment data manager.
internal final class PaymentDataManager {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal private(set) var paymentOptionCellViewModels: [CellViewModel] = [] {
        
        didSet {
            
            self.restorePaymentOptionSelection()
            NotificationCenter.default.post(name: .paymentOptionsModelsUpdated, object: nil)
        }
    }
    
    internal private(set) lazy var currentTheme: Theme = .light
    
    internal var supportedCurrencies: [AmountedCurrency] {
        
        return self.paymentOptionsResponse?.supportedCurrenciesAmounts ?? []
    }
    
    internal var userSelectedCurrency: AmountedCurrency? {
        
        didSet {
            
            self.filterPaymentOptionCellViewModels()
        }
    }
    
    internal private(set) lazy var paymentOptionsScreenCellViewModels: [CellViewModel] = []
    
    internal weak var payButtonUI: PayButtonUI? {
        
        didSet {
            
            self.payButtonUI?.delegate = self
        }
    }
    
    internal var lastSelectedPaymentOption: PaymentOptionCellViewModel?
    
    internal private(set) var externalDataSource: PaymentDataSource?
    internal private(set) var externalDelegate: PaymentDelegate?
    
    internal var orderIdentifier: String? {
        
        return self.paymentOptionsResponse?.orderIdentifier
    }
    
    internal var isExecutingAPICalls = false
    
    internal var transactionCurrency: AmountedCurrency {
        
        guard let nonnullPaymentOptionsResponse = self.paymentOptionsResponse else {
            
            fatalError("Should never reach this place.")
        }
        
        let currency = nonnullPaymentOptionsResponse.currency
        
        guard let amountedCurrency = (self.paymentOptionsResponse?.supportedCurrenciesAmounts.first { $0.currency == currency }) else {
            
            fatalError("Transaction currency is not a supported currency?!")
        }
        
        return amountedCurrency
    }
    
    internal var currentPaymentOption: PaymentOption?
    internal var currentPaymentCardBINNumber: String?
    internal var urlToLoadInWebPaymentController: URL?
    internal var currentCharge: Charge?
    
    internal var paymentOptions: [PaymentOption] {
        
        return self.paymentOptionsResponse?.paymentOptions ?? []
    }
    
    // MARK: Methods
    
    internal func start(with caller: PayButtonInternalImplementation) {
        
        guard !self.isLoadingPaymentOptions else { return }
        
        guard let nonnullDataSource = caller.uiElement?.paymentDataSource else {
            
            fatalError("Pay button data source is not set.")
        }
        
        guard let currency = nonnullDataSource.currency else {
            
            fatalError("Payment data source currency is nil.")
        }
        
        guard let customer = nonnullDataSource.customer else {
            
            fatalError("Payment data source customer is nil.")
        }
        
        self.externalDataSource = nonnullDataSource
        self.externalDelegate = caller.uiElement?.paymentDelegate
        
        let paymentRequest = PaymentOptionsRequest(items:       nonnullDataSource.items,
                                                   shipping:    nonnullDataSource.shipping ?? nil,
                                                   taxes:       nonnullDataSource.taxes ?? nil,
                                                   currency:    currency,
                                                   customer:    customer.identifier)
        
        self.isLoadingPaymentOptions = true
        
        caller.paymentDataManagerDidStartLoadingPaymentOptions()
        
        APIClient.shared.getPaymentOptions(with: paymentRequest) { [weak self, weak caller] (response, error) in
            
            self?.isLoadingPaymentOptions = false
            self?.paymentOptionsResponse = response
            self?.currentTheme = caller?.theme ?? .light
            
            caller?.paymentDataManagerDidStopLoadingPaymentOptions(with: error == nil)
        }
    }
    
    internal func paymentOptionViewModel(at indexPath: IndexPath) -> CellViewModel {
        
        guard let model = (self.paymentOptionCellViewModels.first { $0.indexPath == indexPath }) else {
            
            fatalError("Data source is corrupted")
        }
        
        return model
    }
    
    internal func cellModels<ModelType>(of type: ModelType.Type) -> [ModelType] {
        
        guard let result = (self.paymentOptionsScreenCellViewModels.filter { $0 is ModelType }) as? [ModelType] else {
            
            fatalError("Data source is corrupted")
        }
        
        return result
    }
    
    internal func paymentOptionsControllerKeyboardLayoutFinished() {
        
        guard let selectedModel = self.selectedPaymentOptionCellViewModel as? PaymentOptionTableCellViewModel, selectedModel.isSelected else { return }
        
        selectedModel.tableView?.scrollToRow(at: selectedModel.indexPath, at: .none, animated: false)
    }
    
    internal static func closePayment(_ completion: TypeAlias.ArgumentlessClosure? = nil) {
        
        LoadingViewController.destroyInstance()
        OTPViewController.destroyInstance()
        
        if let paymentContentController = PaymentContentViewController.findInHierarchy() {
            
            paymentContentController.hide {
                
                PaymentDataManager.paymentClosed()
                completion?()
            }
        }
        else {
            
            PaymentDataManager.paymentClosed()
            completion?()
        }
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let recentGroupTitle = "RECENT"
        fileprivate static let othersGroupTitle = "OTHERS"
        
        fileprivate static let spaceBeforeWebPaymentOptionsIdentifier   = "space_before_web_payment_options"
        fileprivate static let spaceBetweenWebAndCardOptionsIdentifier  = "space_between_web_and_card_options"
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
    
    private var isLoadingPaymentOptions = false
    
    private var paymentOptionsResponse: PaymentOptionsResponse? {
        
        didSet {
            
            self.generatePaymentOptionCellViewModels()
        }
    }
    
    private var cardPaymentOptionsCellModel: CardInputTableViewCellModel {
        
        let cardModels = self.cellModels(of: CardInputTableViewCellModel.self)
        
        guard cardModels.count == 1 else {
            
            fatalError("Data source is corrupted")
        }
        
        return cardModels[0]
    }
    
    private var cardsContainerCellModel: CardsContainerTableViewCellModel {
        
        let cardModels = self.cellModels(of: CardsContainerTableViewCellModel.self)
        
        guard cardModels.count == 1 else {
            
            fatalError("Data source is corrupted")
        }
        
        return cardModels[0]
    }
    
    private var recentCards: [SavedCard] {
        
        return self.paymentOptionsResponse?.savedCards ?? []
    }
    
    private static var storage: PaymentDataManager?
    
    // MARK: Methods
    
    private init() {
        
        KnownSingletonTypes.add(PaymentDataManager.self)
    }
    
    private func nextIndexPath(for temporaryCellModels: [CellViewModel]) -> IndexPath {
        
        return IndexPath(row: temporaryCellModels.count, section: 0)
    }
    
    private func paymentOptions(of type: PaymentType) -> [PaymentOption] {
        
        return self.paymentOptions.filter { $0.paymentType == type }
    }
    
    private func generatePaymentOptionCellViewModels() {
        
        guard self.paymentOptionsResponse != nil else {
            
            self.paymentOptionsScreenCellViewModels = []
            return
        }
        
        var result: [CellViewModel] = []
        
        let currencyModel = CurrencySelectionTableViewCellViewModel(indexPath: self.nextIndexPath(for: result),
                                                                    transactionCurrency: self.transactionCurrency,
                                                                    userSelectedCurrency: self.transactionCurrency)
        result.append(currencyModel)
        
        let savedCards = self.recentCards
        let webPaymentOptions = self.paymentOptions(of: .web).sorted { $0.orderBy < $1.orderBy }
        let cardPaymentOptions = self.paymentOptions(of: .card).sorted { $0.orderBy < $1.orderBy }
        
        let hasSavedCards = savedCards.count > 0
        let hasWebPaymentOptions = webPaymentOptions.count > 0
        let hasCardPaymentOptions = cardPaymentOptions.count > 0
        let hasOtherPaymentOptions = hasWebPaymentOptions || hasCardPaymentOptions
        let displaysGroupTitles = hasSavedCards && hasOtherPaymentOptions
        
        if displaysGroupTitles {
            
            let recentGroupModel = GroupTableViewCellModel(indexPath: self.nextIndexPath(for: result), title: Constants.recentGroupTitle)
            result.append(recentGroupModel)
        }
        
        if hasSavedCards {
            
            let cardsContainerCellModel = CardsContainerTableViewCellModel(indexPath: self.nextIndexPath(for: result), cards: savedCards)
            result.append(cardsContainerCellModel)
        }
        
        if displaysGroupTitles {
            
            let othersGroupModel = GroupTableViewCellModel(indexPath: self.nextIndexPath(for: result), title: Constants.othersGroupTitle)
            result.append(othersGroupModel)
        }
        
        if hasWebPaymentOptions {
            
            if !hasSavedCards {
                
                let emptyCellModel = EmptyTableViewCellModel(indexPath: self.nextIndexPath(for: result),
                                                             identifier: Constants.spaceBeforeWebPaymentOptionsIdentifier)
                result.append(emptyCellModel)
            }
            
            webPaymentOptions.forEach {
                
                let webOptionCellModel = WebPaymentOptionTableViewCellModel(indexPath: self.nextIndexPath(for: result),
                                                                            title: $0.title,
                                                                            iconImageURL: $0.imageURL,
                                                                            paymentOption: $0)
                result.append(webOptionCellModel)
            }
        }
        
        if hasCardPaymentOptions {
            
            if hasWebPaymentOptions {
                
                let emptyCellModel = EmptyTableViewCellModel(indexPath: self.nextIndexPath(for: result), identifier: Constants.spaceBetweenWebAndCardOptionsIdentifier)
                result.append(emptyCellModel)
            }
            
            let cardOptionsCellModel = CardInputTableViewCellModel(indexPath: self.nextIndexPath(for: result), paymentOptions: cardPaymentOptions)
            
            result.append(cardOptionsCellModel)
        }
        
        self.paymentOptionsScreenCellViewModels = result
        
        self.filterPaymentOptionCellViewModels()
    }
    
    private func filterPaymentOptionCellViewModels() {
        
        var result: [CellViewModel] = []
        result.append(self.currencyCellViewModel)
        
        let currenciesFilter: (PaymentOption) -> Bool = { option in
            
            if let nonnullUserCurrency = self.userSelectedCurrency?.currency {
                
                return option.supportedCurrencies.contains(nonnullUserCurrency)
            }
            else {
                
                return true
            }
        }
        
        let savedCards = self.recentCards
        let webPaymentOptions = self.paymentOptions(of: .web).filter(currenciesFilter).sorted { $0.orderBy < $1.orderBy }
        let cardPaymentOptions = self.paymentOptions(of: .card).filter(currenciesFilter).sorted { $0.orderBy < $1.orderBy }
        
        let hasSavedCards = savedCards.count > 0
        let hasWebPaymentOptions = webPaymentOptions.count > 0
        let hasCardPaymentOptions = cardPaymentOptions.count > 0
        let hasOtherPaymentOptions = hasWebPaymentOptions || hasCardPaymentOptions
        let displaysGroupTitles = hasSavedCards && hasOtherPaymentOptions
        
        if displaysGroupTitles {
            
            let recentGroupModel = self.groupCellModel(with: Constants.recentGroupTitle)
            recentGroupModel.indexPath = self.nextIndexPath(for: result)
            result.append(recentGroupModel)
        }
        
        if hasSavedCards {
            
            let cardsContainerModel = self.cardsContainerCellModel
            cardsContainerModel.indexPath = self.nextIndexPath(for: result)
            result.append(cardsContainerModel)
        }
        
        if displaysGroupTitles {
            
            let othersGroupModel = self.groupCellModel(with: Constants.othersGroupTitle)
            othersGroupModel.indexPath = self.nextIndexPath(for: result)
            result.append(othersGroupModel)
        }
        
        if hasWebPaymentOptions {
            
            if !hasSavedCards {
                
                let emptyModel = self.emptyCellModel(with: Constants.spaceBeforeWebPaymentOptionsIdentifier)
                emptyModel.indexPath = self.nextIndexPath(for: result)
                
                result.append(emptyModel)
            }
            
            webPaymentOptions.forEach {
                
                let webModel = self.webPaymentCellModel(with: $0.title)
                webModel.indexPath = self.nextIndexPath(for: result)
                
                result.append(webModel)
            }
        }
        
        if hasCardPaymentOptions {
            
            if hasWebPaymentOptions {
                
                let emptyModel = self.emptyCellModel(with: Constants.spaceBetweenWebAndCardOptionsIdentifier)
                emptyModel.indexPath = self.nextIndexPath(for: result)
                
                result.append(emptyModel)
            }
            
            let cardModel = self.cardPaymentOptionsCellModel
            cardModel.indexPath = self.nextIndexPath(for: result)
            cardModel.paymentOptions = cardPaymentOptions
            
            result.append(cardModel)
        }
        
        self.paymentOptionCellViewModels = result
    }
    
    private func groupCellModel(with title: String) -> GroupTableViewCellModel {
        
        let groupModels = self.cellModels(of: GroupTableViewCellModel.self)
        
        for model in groupModels {
            
            if model.title == title {
                
                return model
            }
        }
        
        fatalError("Data source is corrupted")
    }
    
    private func webPaymentCellModel(with title: String) -> WebPaymentOptionTableViewCellModel {
        
        let webModels = self.cellModels(of: WebPaymentOptionTableViewCellModel.self)
        
        for model in webModels {
            
            if model.title == title {
                
                return model
            }
        }
        
        fatalError("Data source is corrupted")
    }
    
    private func emptyCellModel(with identifier: String) -> EmptyTableViewCellModel {
        
        let emptyModels = self.cellModels(of: EmptyTableViewCellModel.self)
        
        for model in emptyModels {
            
            if model.identifier == identifier {
                
                return model
            }
        }
        
        fatalError("Data source is corrupted")
    }
    
    private static func paymentClosed() {
        
        KnownSingletonTypes.destroyAllInstances()
    }
}

// MARK: - Singleton
extension PaymentDataManager: Singleton {
    
    internal static var hasAliveInstance: Bool {
        
        return self.storage != nil
    }
    
    internal static var shared: PaymentDataManager {
        
        if let nonnullStorage = self.storage {
            
            return nonnullStorage
        }
        
        let instance = PaymentDataManager()
        self.storage = instance
        
        return instance
    }
    
    internal static func destroyInstance() {
        
        self.storage = nil
    }
}
