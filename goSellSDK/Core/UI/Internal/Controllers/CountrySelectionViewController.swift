//
//  CountrySelectionViewController.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct   TapAdditionsKitV2.TypeAlias
import class    UIKit.UITableView.UITableView
import protocol UIKit.UITableView.UITableViewDataSource
import protocol UIKit.UITableView.UITableViewDelegate
import class    UIKit.UITableViewCell.UITableViewCell

internal class CountrySelectionViewController: HeaderNavigatedViewControllerWithSearch {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var delegate: CountrySelectionViewControllerDelegate?
    
    // MARK: Methods
    
    internal func setCountries(_ countries: [Country], preselectedCountry: Country) {
        
        self.dataManager = CountriesDataManager(countries: countries, preselectedCountry: preselectedCountry) { [weak self] in
            
            self?.tableView?.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
        
        self.selectCurrentSelectedCell()
    }
    
    internal override func requestToPop(_ decision: @escaping TypeAlias.BooleanClosure) {
        
        self.notifyDelegateIfCountryChanged()
        decision(true)
    }
    
    internal override func tableViewLoaded(_ aTableView: UITableView) {
        
        super.tableViewLoaded(aTableView)
        self.selectCurrentSelectedCell()
    }
    
    internal override func searchViewTextChanged(_ text: String) {
        
        super.searchViewTextChanged(text)
        self.dataManager?.setFilter(text)
    }
    
    // MARK: - Fileprivate -
    // MARK: Methods
    
    fileprivate func model(at indexPath: IndexPath) -> CountryTableViewCellModel {
        
        guard let model = self.dataManager?.filteredData[indexPath.row] else {
            
            fatalError("Data source is corrupted.")
        }
        
        return model
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private var dataManager: CountriesDataManager?
    
    // MARK: Methods
    
    private func selectCurrentSelectedCell() {
        
        guard let selectedIndexPath = self.dataManager?.selectedModelIndexPath else { return }
        guard selectedIndexPath.row < (self.tableView?.numberOfRows(inSection: 0) ?? 0) else { return }
        
        self.tableView?.selectRow(at: selectedIndexPath, animated: false, scrollPosition: .none)
    }
    
    private func notifyDelegateIfCountryChanged() {
        
        guard let manager = self.dataManager else { return }
        
        self.delegate?.countriesSelectionViewControllerDidFinish(with: manager.selectedCountry, changed: manager.hasCountryChanged)
    }
}

// MARK: - TapNavigationView.DataSource
extension CountrySelectionViewController: TapNavigationView.DataSource {
	
	internal func navigationViewCanGoBack(_ navigationView: TapNavigationView) -> Bool {
		
		return (self.navigationController?.viewControllers.count ?? 0) > 1
	}
	
	internal func navigationViewIconPlaceholder(for navigationView: TapNavigationView) -> Image? {
		
		return nil
	}
	
	internal func navigationViewIcon(for navigationView: TapNavigationView) -> Image? {
		
		return nil
	}
	
	internal func navigationViewTitle(for navigationView: TapNavigationView) -> String? {
		
		return "Select Country"
	}
}

// MARK: - UITableViewDataSource
extension CountrySelectionViewController: UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataManager?.filteredData.count ?? 0
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = self.model(at: indexPath)
        
        let cell = model.dequeueCell(from: tableView)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CountrySelectionViewController: UITableViewDelegate {
    
    internal func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let model = self.model(at: indexPath)
        model.updateCell()
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = self.model(at: indexPath)
        self.dataManager?.selectViewModel(model)
    }
}
