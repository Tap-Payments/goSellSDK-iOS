//
//  PaymentDataManager.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

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
    
    internal private(set) lazy var allPaymentOptionCellViewModels: [CellViewModel] = []
    
    internal weak var payButtonUI: PayButtonUI? {
        
        didSet {
            
            self.payButtonUI?.delegate = self
        }
    }
    
    internal var lastSelectedPaymentOption: PaymentOptionCellViewModel?
    
    // MARK: Methods
    
    internal func start(with caller: PayButtonInternalImplementation) {
        
        guard !self.isLoadingPaymentOptions else { return }
        
        guard let nonnullDataSource = caller.uiElement?.dataSource else {
            
            fatalError("Pay button data source is not set.")
        }
        
        guard let currency = nonnullDataSource.currency else {
            
            fatalError("Payment data source currency is nil.")
        }
        
        guard let customer = nonnullDataSource.customer else {
            
            fatalError("Payment data source customer is nil.")
        }
        
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
        
        guard let result = (self.allPaymentOptionCellViewModels.filter { $0 is ModelType }) as? [ModelType] else {
            
            fatalError("Data source is corrupted")
        }
        
        return result
    }
    
    internal func paymentOptionsControllerKeyboardLayoutFinished() {
        
        guard let selectedModel = self.selectedPaymentOptionCellViewModel, selectedModel.isSelected else { return }
        
        selectedModel.tableView?.scrollToRow(at: selectedModel.indexPath, at: .none, animated: false)
    }
    
    internal static func userDidClosePayment() {
        
        KnownSingletonTypes.destroyAllInstances()
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let othersGroupTitle = "OTHERS"
        fileprivate static let spaceBetweenWebAndCardOptionsIdentifier = "space_between_web_and_card_options"
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
    
    private var isLoadingPaymentOptions = false
    
    private var paymentOptionsResponse: PaymentOptionsResponse? {
        
        didSet {
            
            self.generatePaymentOptionCellViewModels()
        }
    }
    
    private var transactionCurrency: AmountedCurrency {
        
        guard let nonnullPaymentOptionsResponse = self.paymentOptionsResponse else {
            
            fatalError("Should never reach this place.")
        }
        
        let currency = nonnullPaymentOptionsResponse.currency
        
        guard let amountedCurrency = (self.paymentOptionsResponse?.supportedCurrenciesAmounts.first { $0.currency == currency }) else {
            
            fatalError("Transaction currency is not a supported currency?!")
        }
        
        return amountedCurrency
    }
    
    private var cardPaymentOptionsCellModel: CardInputTableViewCellModel {
        
        let cardModels = self.cellModels(of: CardInputTableViewCellModel.self)
        
        guard cardModels.count == 1 else {
            
            fatalError("Data source is corrupted")
        }
        
        return cardModels[0]
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
        
        return self.paymentOptionsResponse?.paymentOptions.filter { $0.paymentType == type } ?? []
    }
    
    private func generatePaymentOptionCellViewModels() {
        
        guard self.paymentOptionsResponse != nil else {
            
            self.allPaymentOptionCellViewModels = []
            return
        }
        
        var result: [CellViewModel] = []
        
        // currency model
        
        let currencyModel = CurrencySelectionTableViewCellViewModel(indexPath: self.nextIndexPath(for: result),
                                                                    transactionCurrency: self.transactionCurrency,
                                                                    userSelectedCurrency: self.transactionCurrency)
        result.append(currencyModel)
        
        // web + card payment model
        
        let webPaymentOptions = self.paymentOptions(of: .web).sorted { $0.orderBy < $1.orderBy }
        let cardPaymentOptions = self.paymentOptions(of: .card).sorted { $0.orderBy < $1.orderBy }
        
        if webPaymentOptions.count + cardPaymentOptions.count > 0 {
            
            result.append(GroupTableViewCellModel(indexPath: self.nextIndexPath(for: result), title: Constants.othersGroupTitle))
        }
        
        webPaymentOptions.forEach {
            
            let webOptionCellModel = WebPaymentOptionTableViewCellModel(indexPath: self.nextIndexPath(for: result),
                                                                        title: $0.name.rawValue,
                                                                        iconImageURL: $0.imageURL)
            result.append(webOptionCellModel)
        }
        
        if cardPaymentOptions.count > 0 {
            
            if webPaymentOptions.count > 0 {
                
                let emptyCellModel = EmptyTableViewCellModel(indexPath: self.nextIndexPath(for: result), identifier: Constants.spaceBetweenWebAndCardOptionsIdentifier)
                result.append(emptyCellModel)
            }
            
            let cardOptionsCellModel = CardInputTableViewCellModel(indexPath: self.nextIndexPath(for: result), paymentOptions: cardPaymentOptions)
            
            result.append(cardOptionsCellModel)
        }
        
        self.allPaymentOptionCellViewModels = result
        
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
        
        let webPaymentOptions = self.paymentOptions(of: .web).filter(currenciesFilter).sorted { $0.orderBy < $1.orderBy }
        let cardPaymentOptions = self.paymentOptions(of: .card).filter(currenciesFilter).sorted { $0.orderBy < $1.orderBy }
        
        if webPaymentOptions.count + cardPaymentOptions.count > 0 {
            
            let othersGroupModel = self.groupCellModel(with: Constants.othersGroupTitle)
            othersGroupModel.indexPath = self.nextIndexPath(for: result)
            result.append(othersGroupModel)
        }
        
        webPaymentOptions.forEach {
            
            let webModel = self.webPaymentCellModel(with: $0.name.rawValue)
            webModel.indexPath = self.nextIndexPath(for: result)
            
            result.append(webModel)
        }
        
        if cardPaymentOptions.count > 0 {
            
            if webPaymentOptions.count > 0 {
                
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
}

// MARK: - Singleton
extension PaymentDataManager: Singleton {
    
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
