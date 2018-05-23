//
//  AddressFieldsDataManager+CountrySelection.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal extension AddressFieldsDataManager {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal func setupCountriesSelectionController(_ controller: CountrySelectionViewController) {
        
        guard let countryModel: AddressDropdownFieldTableViewCellModel = self.firstExisingCellModel(with: Constants.countryPlaceholder) else { return }
        guard let selectedCountry = countryModel.preselectedValue as? Country, let allCountries = countryModel.allValues as? [Country] else { return }
        
        controller.delegate = self
        controller.setCountries(allCountries, preselectedCountry: selectedCountry)
    }
}

// MARK: - CountrySelectionViewControllerDelegate
extension AddressFieldsDataManager: CountrySelectionViewControllerDelegate {
    
    internal func countriesSelectionViewControllerDidFinish(with country: Country, changed: Bool) {
        
        let countryModel: AddressDropdownFieldTableViewCellModel? = self.firstExisingCellModel(with: Constants.countryPlaceholder)
        countryModel?.preselectedValue = country
    }
}
