//
//  CurrencyCodesDataManager.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct TapAdditionsKitV2.TypeAlias

/// Data manager to handle currency selection.
internal class CurrencyCodesDataManager {
    
    // MARK: - Internal -
    // MARK: Propeties
    
    internal var filterQuery: String?
    
    internal var selectedModelIndexPath: IndexPath? {
        
        let selectedModel = self.selectedViewModel
        
        if let index = self.filteredData.firstIndex(where: { $0.indexPath == selectedModel.indexPath }) {
        
            return IndexPath(row: index, section: 0)
        }
        else {
            
            return nil
        }
    }
    
    internal let preselectedCurrency: AmountedCurrency
    
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
	
	internal func updateLocalization() {
		
		self.allData.forEach { $0.updateLocalization() }
	}
	
	internal func updateTheme() {
		
		self.allData.forEach { $0.updateTheme() }
	}
	
    // MARK: - Private -
    // MARK: Properties
    
    private let currencies: [AmountedCurrency]
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
        
        for currency in self.currencies {
            
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
