//
//  PaymentDataManager.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal class PaymentDataManager {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal static let shared = PaymentDataManager()
    
    internal private(set) lazy var paymentOptionCellViewModels: [CellViewModel] = []
    
    internal private(set) lazy var currentTheme: Theme = .light
    
    // MARK: Methods
    
    internal func startOver(with caller: PayButtonInternalImplementation) {
        
        guard let nonnullDataSource = caller.uiElement?.dataSource else {
            
            fatalError("Pay button data source is not set.")
        }
        
        let paymentRequest = PaymentOptionsRequest(items: nonnullDataSource.items,
                                                   currency: nonnullDataSource.currency,
                                                   customer: nonnullDataSource.customer)
        
        caller.paymentDataManagerDidStartLoadingPaymentOptions()
        
        APIClient.shared.getPaymentOptions(with: paymentRequest) { [weak self, weak caller] (response, error) in
            
            self?.paymentOptionsResponse = response
            self?.currentTheme = caller?.theme ?? .light
            
            caller?.paymentDataManagerDidStopLoadingPaymentOptions(with: error == nil)
        }
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private var paymentOptionsResponse: PaymentOptionsResponse? {
        
        didSet {
            
            self.updatePaymentOptionCellViewModels()
        }
    }
    
    private var transactionCurrency: AmountedCurrency {
        
        guard let nonnullPaymentOptionsResponse = self.paymentOptionsResponse else {
            
            fatalError("Should never reach this place.")
        }
        
        let currency = nonnullPaymentOptionsResponse.currency
        
        guard let amountedCurrency = (self.paymentOptionsResponse?.supportedCurrenciesAmounts.filter { $0.currency == currency })?.first else {
            
            fatalError("Transaction currency is not a supported currency?!")
        }
        
        return amountedCurrency
    }
    
    // MARK: Methods
    
    private init() { }
    
    private func updatePaymentOptionCellViewModels() {
        
        guard self.paymentOptionsResponse != nil else {
            
            self.paymentOptionCellViewModels = []
            return
        }
        
        var result: [CellViewModel] = []
        
        let currencyModel = CurrencySelectionTableViewCellViewModel(indexPath: self.nextIndexPath(for: result),
                                                                    transactionCurrency: self.transactionCurrency,
                                                                    userSelectedCurrency: self.transactionCurrency)
        result.append(currencyModel)
        
        let webPaymentOptions = self.paymentOptions(of: .web).sorted { $0.orderBy < $1.orderBy }
        let cardPaymentOptions = self.paymentOptions(of: .card).sorted { $0.orderBy < $1.orderBy }
        
        if webPaymentOptions.count + cardPaymentOptions.count > 0 {
            
            result.append(GroupTableViewCellModel(indexPath: self.nextIndexPath(for: result), title: "OTHERS"))
        }
        
        webPaymentOptions.forEach {
            
            let webOptionCellModel = WebPaymentOptionTableViewCellModel(indexPath: self.nextIndexPath(for: result),
                                                                        title: $0.name.rawValue,
                                                                        iconImageURL: $0.imageURL)
            result.append(webOptionCellModel)
        }
        
        if cardPaymentOptions.count > 0 {
            
            let emptyCellModel = EmptyTableViewCellModel(indexPath: self.nextIndexPath(for: result))
            result.append(emptyCellModel)
            
            let cardOptionsCellModel = CardInputTableViewCellModel(indexPath: self.nextIndexPath(for: result), paymentOptions: cardPaymentOptions)
            
            result.append(cardOptionsCellModel)
        }
        
        self.paymentOptionCellViewModels = result
    }
    
    private func nextIndexPath(for temporaryCellModels: [CellViewModel]) -> IndexPath {
        
        return IndexPath(row: temporaryCellModels.count, section: 0)
    }
    
    private func paymentOptions(of type: PaymentType) -> [PaymentOption] {
        
        return self.paymentOptionsResponse?.paymentOptions.filter { $0.paymentType == type } ?? []
    }
}
