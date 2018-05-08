//
//  CurrencyCodesDataManager.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct TapAdditionsKit.TypeAlias

/// Data manager to handle currency selection.
internal class CurrencyCodesDataManager {
    
    // MARK: - Internal -
    // MARK: Propeties
    
    internal var filterQuery: String? {
        
        didSet {
            
            self.updateFilter()
        }
    }
    
    internal var selectedModelIndexPath: IndexPath? {
        
        let selectedModel = self.selectedViewModel
        
        if let index = self.displayedViewModels.index(where: { $0.indexPath == selectedModel.indexPath }) {
        
            return IndexPath(row: index, section: 0)
        }
        else {
            
            return nil
        }
    }
    
    internal var selectedCurrency: AmountedCurrency {
        
        return self.selectedViewModel.amountedCurrency
    }
    
    internal var hasCurrencyChanged: Bool {
        
        return self.preselectedCurrency != self.selectedCurrency
    }
    
    internal private(set) var displayedViewModels: [AmountedCurrencyTableViewCellModel] = []
    
    // MARK: Methods
    
    internal init(currencies: [AmountedCurrency], preselectedCurrency: AmountedCurrency, reloadClosure: @escaping TypeAlias.ArgumentlessClosure) {
        
        self.currencies = currencies.sorted { $0.readableCurrencyName < $1.readableCurrencyName }
        self.preselectedCurrency = preselectedCurrency
        self.reloadDataClosure = reloadClosure
        
        self.generateCellsViewModels()
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private let currencies: [AmountedCurrency]
    private let preselectedCurrency: AmountedCurrency
    private let reloadDataClosure: TypeAlias.ArgumentlessClosure
    
    private var allCellsViewModels: [AmountedCurrencyTableViewCellModel] = []
    
    private var selectedViewModel: AmountedCurrencyTableViewCellModel {
        
        
        
        guard let result = (self.allCellsViewModels.first { $0.isSelected }) else {
            
            fatalError("Currency code data manager is corrupted.")
        }
        
        return result
    }
    
    // MARK: Methods
    
    private func generateCellsViewModels() {
        
        var result: [AmountedCurrencyTableViewCellModel] = []
        
        for currency in currencies {
            
            let indexPath = self.nextIndexPath(for: result)
            let model = AmountedCurrencyTableViewCellModel(indexPath: indexPath, amountedCurrency: currency)
            model.isSelected = currency == self.preselectedCurrency
            
            result.append(model)
        }
        
        self.allCellsViewModels = result
        self.updateFilter()
    }
    
    private func updateFilter() {
        
        guard let filter = self.filterQuery, filter.length > 0 else {
            
            self.displayedViewModels = self.allCellsViewModels
            return
        }
        
        self.displayedViewModels = self.allCellsViewModels.filter { $0.currencyNameText.contains(filter) }
        
        self.reloadDataClosure()
    }
    
    @inline(__always) private func nextIndexPath(for temporaryResult: [Any]) -> IndexPath {
        
        return IndexPath(row: temporaryResult.count, section: 0)
    }
}
