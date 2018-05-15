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
    
    internal var filterQuery: String?
    
    internal var selectedModelIndexPath: IndexPath? {
        
        let selectedModel = self.selectedViewModel
        
        if let index = self.filteredData.index(where: { $0.indexPath == selectedModel.indexPath }) {
        
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
    
    internal var filteredData: [AmountedCurrencyTableViewCellModel] = [] {
        
        didSet {
            
            self.reloadDataClosure()
        }
    }
    
    internal private(set) var allData: [AmountedCurrencyTableViewCellModel] = []
    
    // MARK: Methods
    
    internal init(currencies: [AmountedCurrency], preselectedCurrency: AmountedCurrency, reloadClosure: @escaping TypeAlias.ArgumentlessClosure) {
        
        self.currencies = currencies.sorted { $0.readableCurrencyName < $1.readableCurrencyName }
        self.preselectedCurrency = preselectedCurrency
        self.reloadDataClosure = reloadClosure
        
        self.generateCellsViewModels()
    }
    
    internal func selectViewModel(_ model: AmountedCurrencyTableViewCellModel) {
        
        self.allData.forEach { $0.isSelected = $0 === model }
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private let currencies: [AmountedCurrency]
    private let preselectedCurrency: AmountedCurrency
    private let reloadDataClosure: TypeAlias.ArgumentlessClosure
    
    private var selectedViewModel: AmountedCurrencyTableViewCellModel {
        
        guard let result = (self.allData.first { $0.isSelected }) else {
            
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
        
        self.allData = result
        self.setFilter(nil)
    }
    
    @inline(__always) private func nextIndexPath(for temporaryResult: [Any]) -> IndexPath {
        
        return IndexPath(row: temporaryResult.count, section: 0)
    }
}

// MARK: - DataManagerWithFilteredData
extension CurrencyCodesDataManager: DataManagerWithFilteredData {}
