//
//  CountriesDataManager.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct TapAdditionsKitV2.TypeAlias

internal class CountriesDataManager {
    
    // MARK: - Internal -
    // MARK: Properties
    
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
    
    internal var selectedCountry: Country {
        
        return self.selectedViewModel.country
    }
    
    internal var hasCountryChanged: Bool {
        
        return self.preselectedCountry != self.selectedCountry
    }
    
    internal var filteredData: [CountryTableViewCellModel] = [] {
        
        didSet {
            
            self.reloadDataClosure()
        }
    }
    
    internal private(set) var allData: [CountryTableViewCellModel] = []
    
    // MARK: Methods
    
    internal init(countries: [Country], preselectedCountry: Country, reloadDataClosure: @escaping TypeAlias.ArgumentlessClosure) {
        
        self.countries = countries.sorted { $0.displayInTheListValue < $1.displayInTheListValue }
        self.preselectedCountry = preselectedCountry
        self.reloadDataClosure = reloadDataClosure
        
        self.generateCellViewModels()
    }
    
    internal func selectViewModel(_ model: CountryTableViewCellModel) {
        
        self.allData.forEach { $0.isSelected = $0 === model }
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private let countries: [Country]
    private let preselectedCountry: Country
    private let reloadDataClosure: TypeAlias.ArgumentlessClosure
    
    private var selectedViewModel: CountryTableViewCellModel {
        
        guard let result = self.allData.first(where: { $0.isSelected }) else {
         
            fatalError("Countries data manager is corrupted.")
        }
        
        return result
    }
    
    // MARK: Methods
    
    private func generateCellViewModels() {
        
        var result: [CountryTableViewCellModel] = []
        
        for country in self.countries {
            
            let indexPath = self.nextIndexPath(for: result)
            let model = CountryTableViewCellModel(indexPath: indexPath, country: country)
            model.isSelected = country == self.preselectedCountry
            
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
extension CountriesDataManager: DataManagerWithFilteredData {}
