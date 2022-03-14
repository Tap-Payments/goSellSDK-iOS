//
//  Process.ViewModelsHandler.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct    TapBundleLocalization.LocalizationKey
import PassKit

internal protocol ViewModelsHandlerInterface {
    
    var paymentOptionCellViewModels: [CellViewModel] { get }
    var selectedPaymentOptionCellViewModel: PaymentOptionCellViewModel? { get }
    func paymentOptionViewModel(at indexPath: IndexPath) -> CellViewModel
    
    var currencyCellViewModel: CurrencySelectionTableViewCellViewModel { get }
    var cardsContainerCellModel: CardsContainerTableViewCellModel { get }
    var cardPaymentOptionsCellModel: CardInputTableViewCellModel { get }
    
    func cellModels<ModelType>(of type: ModelType.Type) -> [ModelType]
    
    func updateViewModels()
    func scrollToSelectedModel()
    func restorePaymentOptionSelection()
    func generatePaymentOptionCellViewModels()
    
    func currencyChanged()
    func isInDeleteSavedCardsModeStateChanged()
    
    func groupWithButtonModelButtonClicked()
    
    func deselectPaymentOption(_ model: PaymentOptionCellViewModel)
    func deselectAllPaymentOptionsModels(except model: PaymentOptionCellViewModel)
    func deselectAllPaymentOptionsModels()
}

internal extension Process {
    
    class ViewModelsHandler: ViewModelsHandlerInterface {
        
        // MARK: - Internal -
        // MARK: Properties
        
        internal unowned let process: ProcessInterface
        
        /// All cell view models.
        internal lazy var paymentOptionsScreenCellViewModels: [CellViewModel] = []
        
        /// Currently visible cell view models.
        internal var paymentOptionCellViewModels: [CellViewModel] = [] {
            
            didSet {
                
                self.restorePaymentOptionSelection()
                NotificationCenter.default.post(name: .tap_paymentOptionsModelsUpdated, object: nil)
            }
        }
        
        func restorePaymentOptionSelection() { }
        
        internal var selectedPaymentOptionCellViewModel: PaymentOptionCellViewModel? {
            
            return self.ableToBeSelectedPaymentOptionCellModels.first { $0.isSelected }
        }
        
        internal var lastSelectedPaymentOption: PaymentOptionCellViewModel?
        
        internal var cardPaymentOptionsCellModel: CardInputTableViewCellModel {
            
            let cardModels = self.cellModels(of: CardInputTableViewCellModel.self)
            
            guard cardModels.count == 1 else {
                
                fatalError("Data source is corrupted")
            }
            
            return cardModels[0]
        }
        
        internal var currencyCellViewModel: CurrencySelectionTableViewCellViewModel {
            
            guard let result = (self.paymentOptionsScreenCellViewModels.first { $0 is CurrencySelectionTableViewCellViewModel }) as? CurrencySelectionTableViewCellViewModel else {
                
                fatalError("Payment data manager is corrupted.")
            }
            
            return result
        }
        
        internal var cardsContainerCellModel: CardsContainerTableViewCellModel {
            
            let cardModels = self.cellModels(of: CardsContainerTableViewCellModel.self)
            
            guard cardModels.count == 1 else {
                
                fatalError("Data source is corrupted")
            }
            
            return cardModels[0]
        }
        
        // MARK: Methods
        
        internal required init(process: ProcessInterface) {
            
            self.process = process
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
        
        internal func updateViewModels() {
            
            self.generatePaymentOptionCellViewModels()
        }
        
        internal func generatePaymentOptionCellViewModels() {
            
            fatalError("Should be implemented in extension")
        }
        
        internal func deselectPaymentOption(_ model: PaymentOptionCellViewModel) {}
        
        internal func deselectAllPaymentOptionsModels(except model: PaymentOptionCellViewModel) {}
        
        internal func deselectAllPaymentOptionsModels() {}
        
        internal func currencyChanged() {}
        
        internal func groupWithButtonModelButtonClicked() {
            
            fatalError("Should be implemented in extension")
        }
        
        
        
        internal func scrollToSelectedModel() {
            
            guard let selectedModel = self.selectedPaymentOptionCellViewModel as? PaymentOptionTableCellViewModel, selectedModel.isSelected else { return }
            
            selectedModel.tableView?.scrollToRow(at: selectedModel.indexPath, at: .none, animated: false)
        }
        
        internal func isInDeleteSavedCardsModeStateChanged() {
            
            fatalError("Should be implemented in extension")
        }
        
        // MARK: - Private -
        // MARK: Properties
        
        internal var ableToBeSelectedPaymentOptionCellModels: [PaymentOptionCellViewModel] {
            
            let topLevelModels = (self.paymentOptionsScreenCellViewModels.filter { $0 is PaymentOptionCellViewModel } as? [PaymentOptionCellViewModel]) ?? []
            let savedCardsModels = self.cellModels(of: CardsContainerTableViewCellModel.self).first?.collectionViewCellModels ?? []
            
            return topLevelModels + savedCardsModels
        }
        
        // MARK: Methods
        
        internal func groupCellModel(with key: LocalizationKey) -> GroupTableViewCellModel {
            
            if let existing = self.cellModels(of: GroupTableViewCellModel.self).first(where: { $0.key == key }) {
                
                return existing
            }
            
            let newModel = GroupTableViewCellModel(indexPath: self.nextIndexPath(for: self.paymentOptionsScreenCellViewModels), key: key)
            self.paymentOptionsScreenCellViewModels.append(newModel)
            
            return newModel
        }
        
        internal func groupWithButtonCellModel(with key: LocalizationKey) -> GroupWithButtonTableViewCellModel {
            
            if let existing = self.cellModels(of: GroupWithButtonTableViewCellModel.self).first(where: { $0.key == key }) {
                
                return existing
            }
            
            let newModel = GroupWithButtonTableViewCellModel(indexPath: self.nextIndexPath(for: self.paymentOptionsScreenCellViewModels), key: key)
            self.paymentOptionsScreenCellViewModels.append(newModel)
            
            return newModel
        }
        
        internal func webPaymentCellModel(with paymentOption: PaymentOption) -> WebPaymentOptionTableViewCellModel {
            
            let webModels = self.cellModels(of: WebPaymentOptionTableViewCellModel.self)
            
            for model in webModels {
                
                if model.paymentOption == paymentOption {
                    
                    return model
                }
            }
            
            let newModel = WebPaymentOptionTableViewCellModel(indexPath: self.nextIndexPath(for: self.paymentOptionsScreenCellViewModels), paymentOption: paymentOption)
            self.paymentOptionsScreenCellViewModels.append(newModel)
            
            return newModel
        }
        
        
        internal func applePaymentCellModel(with paymentOption: PaymentOption) -> ApplePaymentOptionTableViewCellModel {
            
            let applePayModels = self.cellModels(of: ApplePaymentOptionTableViewCellModel.self)
            
            for model in applePayModels {
                
                if model.paymentOption == paymentOption {
                    
                    return model
                }
            }
            
            let newModel = ApplePaymentOptionTableViewCellModel(indexPath: self.nextIndexPath(for: self.paymentOptionsScreenCellViewModels), paymentOption: paymentOption)
            self.paymentOptionsScreenCellViewModels.append(newModel)
            
            return newModel
        }
        
        internal func emptyCellModel(with identifier: String) -> EmptyTableViewCellModel {
            
            let emptyModels = self.cellModels(of: EmptyTableViewCellModel.self)
            
            for model in emptyModels {
                
                if model.identifier == identifier {
                    
                    return model
                }
            }
            
            let newModel = EmptyTableViewCellModel(indexPath: self.nextIndexPath(for: self.paymentOptionsScreenCellViewModels), identifier: identifier)
            self.paymentOptionsScreenCellViewModels.append(newModel)
            
            return newModel
        }
        
        internal func nextIndexPath(for temporaryCellModels: [CellViewModel]) -> IndexPath {
            
            return IndexPath(row: temporaryCellModels.count, section: 0)
        }
        
        fileprivate typealias Constants = __ViewModelsHandlerConstants
    }
    
    final class PaymentViewModelsHandler: ViewModelsHandler {
        
        // MARK: - Internal -
        // MARK: Methods
        
        internal override func isInDeleteSavedCardsModeStateChanged() {
            
            let savedCardsModels = self.cellModels(of: CardsContainerTableViewCellModel.self).first?.collectionViewCellModels ?? []
            savedCardsModels.forEach { $0.isDeleteCellMode = self.process.dataManagerInterface.isInDeleteSavedCardsMode }
            
            let recentGroupModel = self.cellModels(of: GroupWithButtonTableViewCellModel.self).first
            recentGroupModel?.updateButtonTitle(self.process.dataManagerInterface.isInDeleteSavedCardsMode)
        }
        
        internal override func groupWithButtonModelButtonClicked() {
            
            self.process.dataManagerInterface.groupWithButtonButtonClickAction?()
        }
        
        internal override func deselectAllPaymentOptionsModels() {
            
            self.ableToBeSelectedPaymentOptionCellModels.forEach { $0.isSelected = false }
            self.process.buttonHandlerInterface.updateButtonState()
        }
        
        internal override func deselectAllPaymentOptionsModels(except model: PaymentOptionCellViewModel) {
            
            if self.process.dataManagerInterface.isInDeleteSavedCardsMode && model is CardCollectionViewCellModel {
                
                self.deselectAllPaymentOptionsModels()
                self.process.buttonHandlerInterface.updateButtonState()
                return
            }
            else if self.process.dataManagerInterface.isInDeleteSavedCardsMode {
                
                self.process.dataManagerInterface.isInDeleteSavedCardsMode = false
            }
            
            let allModels = self.ableToBeSelectedPaymentOptionCellModels
            
            allModels.forEach { $0.isSelected = $0 === model }
            
            self.lastSelectedPaymentOption = model
            
            self.process.buttonHandlerInterface.updateButtonState()
            
            if model.initiatesPaymentOnSelection {
                
                self.process.startPayment(with: model)
                
                self.deselectPaymentOption(model)
            }
        }
        
        internal override func deselectPaymentOption(_ model: PaymentOptionCellViewModel) {
            
            self.lastSelectedPaymentOption = nil
            model.isSelected = false
            
            self.process.buttonHandlerInterface.updateButtonState()
        }
        
        internal override func restorePaymentOptionSelection() {
            
            if let nonnullLastSelectedPaymentOption = self.lastSelectedPaymentOption {
                
                self.deselectAllPaymentOptionsModels(except: nonnullLastSelectedPaymentOption)
            }
            else {
                
                let paymentOptionsModels = self.cellModels(of: PaymentOptionTableCellViewModel.self)
                paymentOptionsModels.forEach { $0.isSelected = false }
            }
        }
        
        internal override func currencyChanged() {
            
            self.filterPaymentOptionCellViewModels()
        }
        
        internal override func generatePaymentOptionCellViewModels() {
            
            guard self.process.dataManagerInterface.paymentOptionsResponse != nil else {
                
                self.paymentOptionsScreenCellViewModels = []
                return
            }
            
            var result: [CellViewModel] = []
            
            let currencyModel = CurrencySelectionTableViewCellViewModel(indexPath:                self.nextIndexPath(for: result),
                                                                        transactionCurrency:    self.process.dataManagerInterface.transactionCurrency,
                                                                        userSelectedCurrency:    self.process.dataManagerInterface.selectedCurrency)
            result.append(currencyModel)
            
            let savedCards = self.process.dataManagerInterface.recentCards
            
            let sortingClosure: (SortableByOrder, SortableByOrder) -> Bool = { $0.orderBy < $1.orderBy }
            
            let webPaymentOptions = self.process.dataManagerInterface.paymentOptions(of: .web).sorted(by: sortingClosure)
            let cardPaymentOptions = self.process.dataManagerInterface.paymentOptions(of: .card).sorted(by: sortingClosure)
            let applePaymentOptions = self.process.dataManagerInterface.paymentOptions(of: .apple).sorted(by: sortingClosure)
            
            let hasSavedCards = savedCards.count > 0
            let hasWebPaymentOptions = webPaymentOptions.count > 0
            let hasCardPaymentOptions = cardPaymentOptions.count > 0
            let hasApplaPaymentOption = applePaymentOptions.count > 0 && ((Process.shared.process.externalSession?.dataSource?.applePayMerchantID ?? "").hasPrefix("merchant."))
            let hasOtherPaymentOptions = hasWebPaymentOptions || hasCardPaymentOptions || hasApplaPaymentOption
            let displaysGroupTitles = hasSavedCards && hasOtherPaymentOptions
            
            if displaysGroupTitles {
                
                let recentGroupModel = GroupWithButtonTableViewCellModel(indexPath: self.nextIndexPath(for: result), key: Constants.recentGroupModelKey)
                result.append(recentGroupModel)
            }
            
            if hasSavedCards {
                
                let cardsContainerCellModel = CardsContainerTableViewCellModel(indexPath: self.nextIndexPath(for: result), cards: savedCards)
                result.append(cardsContainerCellModel)
            }
            
            if displaysGroupTitles {
                
                let othersGroupModel = GroupTableViewCellModel(indexPath: self.nextIndexPath(for: result), key: Constants.othersGroupModelKey)
                result.append(othersGroupModel)
            }
            
            if hasApplaPaymentOption
            {
                if !hasSavedCards {
                    
                    let emptyCellModel = EmptyTableViewCellModel(indexPath: self.nextIndexPath(for: result),
                                                                 identifier: Constants.spaceBetweenCurrencyAndApplePayOptionsIdentifier)
                    result.append(emptyCellModel)
                }
                
                applePaymentOptions.forEach {
                    
                    let applePayOptionCellModel = ApplePaymentOptionTableViewCellModel(indexPath: self.nextIndexPath(for: result),
                                                                                       paymentOption: $0)
                    result.append(applePayOptionCellModel)
                }
            }
            
            if hasWebPaymentOptions {
                
                if !hasSavedCards || hasApplaPaymentOption {
                    
                    let emptyCellModel = EmptyTableViewCellModel(indexPath: self.nextIndexPath(for: result),
                                                                 identifier: Constants.spaceBeforeWebPaymentOptionsIdentifier)
                    result.append(emptyCellModel)
                }
                
                webPaymentOptions.forEach {
                    
                    let webOptionCellModel = WebPaymentOptionTableViewCellModel(indexPath: self.nextIndexPath(for: result),
                                                                                paymentOption: $0)
                    result.append(webOptionCellModel)
                }
            }
            
            if hasCardPaymentOptions {
                
                if hasWebPaymentOptions || !displaysGroupTitles || hasApplaPaymentOption {
                    
                    let emptyCellModel = EmptyTableViewCellModel(indexPath: self.nextIndexPath(for: result),
                                                                 identifier: Constants.spaceBetweenWebAndCardOptionsIdentifier)
                    result.append(emptyCellModel)
                }
                
                let cardOptionsCellModel = CardInputTableViewCellModel(indexPath: self.nextIndexPath(for: result), paymentOptions: cardPaymentOptions)
                
                result.append(cardOptionsCellModel)
            }
            
            self.paymentOptionsScreenCellViewModels = result
            
            self.filterPaymentOptionCellViewModels()
        }
        
        internal func filterPaymentOptionCellViewModels() {
            
            var result: [CellViewModel] = []
            result.append(self.currencyCellViewModel)
            
            let currency = self.process.dataManagerInterface.selectedCurrency.currency
            var paymentNetworks = [PKPaymentNetwork.amex, PKPaymentNetwork.masterCard,  PKPaymentNetwork.visa]
            if #available(iOS 12.0, *) {
                paymentNetworks.append(contentsOf: [PKPaymentNetwork.electron,PKPaymentNetwork.maestro])
            } else {
                // Fallback on earlier versions
            }
            if #available(iOS 12.1.1, *) {
                paymentNetworks.append(PKPaymentNetwork.mada)
            } else {
                // Fallback on earlier versions
            }
            
            let currenciesFilter: (FilterableByCurrency) -> Bool = { $0.supportedCurrencies.contains(currency) }
            let sortingClosure: (SortableByOrder, SortableByOrder) -> Bool = { $0.orderBy < $1.orderBy }
            
            let savedCards = self.process.dataManagerInterface.recentCards.filter(currenciesFilter).sorted(by: sortingClosure)
            let webPaymentOptions = self.process.dataManagerInterface.paymentOptions(of: .web).filter(currenciesFilter).sorted(by: sortingClosure)
            let applePaymentOptions = PKPaymentAuthorizationViewController.canMakePayments() ? self.process.dataManagerInterface.paymentOptions(of: .apple).filter(currenciesFilter).sorted(by: sortingClosure) : []
            let cardPaymentOptions = self.process.dataManagerInterface.paymentOptions(of: .card).filter(currenciesFilter).sorted(by: sortingClosure)
            let hasApplaPaymentOption = applePaymentOptions.count > 0 && ((Process.shared.process.externalSession?.dataSource?.applePayMerchantID ?? "").hasPrefix("merchant."))
            
            let hasSavedCards = savedCards.count > 0
            let hasWebPaymentOptions = webPaymentOptions.count > 0
            let hasCardPaymentOptions = cardPaymentOptions.count > 0
            let hasOtherPaymentOptions = hasWebPaymentOptions || hasCardPaymentOptions || hasApplaPaymentOption
            let displaysGroupTitles = hasSavedCards && hasOtherPaymentOptions
            
            if displaysGroupTitles {
                
                let recentGroupModel = self.groupWithButtonCellModel(with: Constants.recentGroupModelKey)
                recentGroupModel.indexPath = self.nextIndexPath(for: result)
                result.append(recentGroupModel)
            }
            
            if hasSavedCards {
                
                let cardsContainerModel = self.cardsContainerCellModel
                cardsContainerModel.indexPath = self.nextIndexPath(for: result)
                cardsContainerModel.updateData(with: savedCards)
                result.append(cardsContainerModel)
            }
            
            if displaysGroupTitles {
                
                let othersGroupModel = self.groupCellModel(with: Constants.othersGroupModelKey)
                othersGroupModel.indexPath = self.nextIndexPath(for: result)
                result.append(othersGroupModel)
            }
            
            if hasApplaPaymentOption
            {
                if !hasSavedCards {
                    
                    let emptyModel = self.emptyCellModel(with: Constants.spaceBetweenCurrencyAndApplePayOptionsIdentifier)
                    emptyModel.indexPath = self.nextIndexPath(for: result)
                    
                    result.append(emptyModel)
                }
                
                applePaymentOptions.forEach {
                    
                    let applePayModel = self.applePaymentCellModel(with: $0)
                    applePayModel.indexPath = self.nextIndexPath(for: result)
                    
                    result.append(applePayModel)
                }
            }
            
            
            if hasWebPaymentOptions {
                
                if !hasSavedCards || hasApplaPaymentOption {
                    
                    let emptyModel = self.emptyCellModel(with: Constants.spaceBeforeWebPaymentOptionsIdentifier)
                    emptyModel.indexPath = self.nextIndexPath(for: result)
                    
                    result.append(emptyModel)
                }
                
                webPaymentOptions.forEach {
                    
                    let webModel = self.webPaymentCellModel(with: $0)
                    webModel.indexPath = self.nextIndexPath(for: result)
                    
                    result.append(webModel)
                }
            }
            
            
            
            
            
            if hasCardPaymentOptions {
                
                if hasWebPaymentOptions || !displaysGroupTitles || hasApplaPaymentOption {
                    
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
    }
    
    final class CardSavingViewModelsHandler: ViewModelsHandler {
        
        internal override var selectedPaymentOptionCellViewModel: PaymentOptionCellViewModel? {
            
            return self.cardPaymentOptionsCellModel
        }
        
        internal override func restorePaymentOptionSelection() { }
        
        internal override func generatePaymentOptionCellViewModels() {
            
            guard self.process.dataManagerInterface.paymentOptionsResponse != nil else {
                
                self.paymentOptionsScreenCellViewModels = []
                return
            }
            
            let sortingClosure: (SortableByOrder, SortableByOrder) -> Bool = { $0.orderBy < $1.orderBy }
            let cardPaymentOptions = self.process.dataManagerInterface.paymentOptions(of: .card).sorted(by: sortingClosure)
            
            var result: [CellViewModel] = []
            
            if cardPaymentOptions.count > 0 {
                
                if Process.shared.appearance == .fullscreen {
                    
                    let emptyCellModel = EmptyTableViewCellModel(indexPath: self.nextIndexPath(for: result),
                                                                 identifier: Constants.spaceBetweenWebAndCardOptionsIdentifier)
                    result.append(emptyCellModel)
                }
                
                let cardOptionsCellModel = CardInputTableViewCellModel(indexPath:        self.nextIndexPath(for: result),
                                                                       paymentOptions:    cardPaymentOptions)
                
                result.append(cardOptionsCellModel)
            }
            
            self.paymentOptionsScreenCellViewModels = result
            
            self.filterPaymentOptionCellViewModels()
        }
        
        internal func filterPaymentOptionCellViewModels() {
            
            var result: [CellViewModel] = []
            
            let currency = self.process.dataManagerInterface.selectedCurrency.currency
            
            let currenciesFilter: (FilterableByCurrency) -> Bool = { $0.supportedCurrencies.contains(currency) }
            let sortingClosure: (SortableByOrder, SortableByOrder) -> Bool = { $0.orderBy < $1.orderBy }
            
            let cardPaymentOptions = self.process.dataManagerInterface.paymentOptions(of: .card).filter(currenciesFilter).sorted(by: sortingClosure)
            
            if cardPaymentOptions.count > 0 {
                
                if Process.shared.appearance == .fullscreen {
                    
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
    }
    
    final class CardTokenizationViewModelsHandler: ViewModelsHandler {
        
        internal override var selectedPaymentOptionCellViewModel: PaymentOptionCellViewModel? {
            
            return self.lastSelectedPaymentOption
        }
        
        internal override func restorePaymentOptionSelection() { }
        
        internal override func generatePaymentOptionCellViewModels() {
            
            guard self.process.dataManagerInterface.paymentOptionsResponse != nil else {
                
                self.paymentOptionsScreenCellViewModels = []
                return
            }
            
            let sortingClosure: (SortableByOrder, SortableByOrder) -> Bool = { $0.orderBy < $1.orderBy }
            let cardPaymentOptions = self.process.dataManagerInterface.paymentOptions(of: .card).sorted(by: sortingClosure)
            
            var result: [CellViewModel] = []
            
            if cardPaymentOptions.count > 0 {
                
                if Process.shared.appearance == .fullscreen {
                    
                    let emptyCellModel = EmptyTableViewCellModel(indexPath: self.nextIndexPath(for: result),
                                                                 identifier: Constants.spaceBetweenWebAndCardOptionsIdentifier)
                    result.append(emptyCellModel)
                }
                
                let cardOptionsCellModel = CardInputTableViewCellModel(indexPath:        self.nextIndexPath(for: result),
                                                                       paymentOptions:    cardPaymentOptions)
                
                result.append(cardOptionsCellModel)
            }
            
            self.paymentOptionsScreenCellViewModels = result
            
            self.filterPaymentOptionCellViewModels()
        }
        
        internal func filterPaymentOptionCellViewModels() {
            
            var result: [CellViewModel] = []
            
            let currency = self.process.dataManagerInterface.selectedCurrency.currency
            
            var paymentNetworks = [PKPaymentNetwork.amex, PKPaymentNetwork.masterCard,  PKPaymentNetwork.visa]
            if #available(iOS 12.0, *) {
                paymentNetworks.append(contentsOf: [PKPaymentNetwork.electron,PKPaymentNetwork.maestro])
            } else {
                // Fallback on earlier versions
            }
            if #available(iOS 12.1.1, *) {
                paymentNetworks.append(PKPaymentNetwork.mada)
            } else {
                // Fallback on earlier versions
            }
            
            
            let currenciesFilter: (FilterableByCurrency) -> Bool = { $0.supportedCurrencies.contains(currency) }
            let sortingClosure: (SortableByOrder, SortableByOrder) -> Bool = { $0.orderBy < $1.orderBy }
            
            let applePaymentOptions = PKPaymentAuthorizationViewController.canMakePayments() ? self.process.dataManagerInterface.paymentOptions(of: .apple).filter(currenciesFilter).sorted(by: sortingClosure) : []
            let hasApplePaymentOption = applePaymentOptions.count > 0 && ((Process.shared.process.externalSession?.dataSource?.applePayMerchantID ?? "").hasPrefix("merchant."))
            let hasOtherPaymentOptions = hasApplePaymentOption
            let displaysGroupTitles = hasOtherPaymentOptions
            
            let cardPaymentOptions = self.process.dataManagerInterface.paymentOptions(of: .card).filter(currenciesFilter).sorted(by: sortingClosure)
            
            
            if displaysGroupTitles {
                
                let othersGroupModel = self.groupCellModel(with: Constants.othersGroupModelKey)
                othersGroupModel.indexPath = self.nextIndexPath(for: result)
                result.append(othersGroupModel)
            }
            
            if hasApplePaymentOption
            {
                let emptyModel = self.emptyCellModel(with: Constants.spaceBetweenCurrencyAndApplePayOptionsIdentifier)
                emptyModel.indexPath = self.nextIndexPath(for: result)
                
                result.append(emptyModel)
                
                applePaymentOptions.forEach {
                    
                    let applePayModel = self.applePaymentCellModel(with: $0)
                    applePayModel.indexPath = self.nextIndexPath(for: result)
                    result.append(applePayModel)
                }
            }
            
            
            if cardPaymentOptions.count > 0 {
                
                if Process.shared.appearance == .fullscreen {
                    
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
        
        
        
        internal override func deselectAllPaymentOptionsModels(except model: PaymentOptionCellViewModel) {
            
            guard  model is ApplePaymentOptionTableViewCellModel || model is CardInputTableViewCellModel else {
                
                self.deselectAllPaymentOptionsModels()
                self.process.buttonHandlerInterface.updateButtonState()
                return
            }
            
            
            let allModels = self.ableToBeSelectedPaymentOptionCellModels
            
            allModels.forEach { $0.isSelected = $0 === model }
            
            self.lastSelectedPaymentOption = model
            
            self.process.buttonHandlerInterface.updateButtonState()
            
            if model.initiatesPaymentOnSelection {
                
                self.process.startPayment(with: model)
                
                self.deselectPaymentOption(model)
            }
        }
        
    }
}

private struct __ViewModelsHandlerConstants {
    
    fileprivate static let recentGroupModelKey: LocalizationKey = .payment_options_group_title_recent
    fileprivate static let othersGroupModelKey: LocalizationKey = .payment_options_group_title_others
    
    fileprivate static let spaceBeforeWebPaymentOptionsIdentifier   = "space_before_web_payment_options"
    fileprivate static let spaceBetweenWebAndCardOptionsIdentifier  = "space_between_web_and_card_options"
    fileprivate static let spaceBetweenCardAndApplePayOptionsIdentifier  = "space_between_card_and_apple_options"
    fileprivate static let spaceBetweenCurrencyAndApplePayOptionsIdentifier  = "space_between_currency_and_apple_options"
    
    //@available(*, unavailable) private init() { }
}
