//
//  AddressFieldsDataManager+CountrySelection.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal extension AddressFieldsDataManager {
    
    // MARK: - Internal -
    // MARK: Properties
    
    var countryCellModel: AddressDropdownFieldTableViewCellModel {
        
        let addressModels = self.cellViewModels.compactMap { $0 as? AddressDropdownFieldTableViewCellModel }
        
        guard let result = addressModels.first(where: { $0.addressField.name == Constants.countryFieldName }) else {
            
            fatalError("Country is not there.")
        }
        
        return result
    }
    
    // MARK: Methods
    
    func setupCountriesSelectionController(_ controller: CountrySelectionViewController) {
        
        let countryModel = self.countryCellModel
        
        guard let selectedCountry = countryModel.preselectedValue as? Country,
              let allCountries = countryModel.allValues as? [Country] else { return }
        
        controller.delegate = self
        controller.setCountries(allCountries, preselectedCountry: selectedCountry)
    }
}

// MARK: - CountrySelectionViewControllerDelegate
extension AddressFieldsDataManager: CountrySelectionViewControllerDelegate {
    
    internal func countriesSelectionViewControllerDidFinish(with country: Country, changed: Bool) {
        
        if changed {
            
            self.country = country
        }
    }
}
