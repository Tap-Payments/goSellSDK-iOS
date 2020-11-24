//
//  CurrencySelectionViewController.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct   TapAdditionsKitV2.TypeAlias
import func     TapSwiftFixesV2.performOnMainThread
import enum		UIKit.UIApplication.UIStatusBarStyle
import class    UIKit.UIButton.UIButton
import class    UIKit.UIImageView.UIImageView
import class    UIKit.UILabel.UILabel
import class    UIKit.UITableView.UITableView
import protocol UIKit.UITableView.UITableViewDataSource
import protocol UIKit.UITableView.UITableViewDelegate
import class    UIKit.UITableViewCell.UITableViewCell

internal class CurrencySelectionViewController: HeaderNavigatedViewControllerWithSearch {
    
    // MARK: - Internal -
    // MARK: Properties
	
	internal override var preferredStatusBarStyle: UIStatusBarStyle {
		
		return Theme.current.commonStyle.statusBar[Process.shared.appearance].uiStatusBarStyle
	}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchView?.setBackGround(UIColor.tap_hex("#F7F7F7").loadCompatibleDarkModeColor(forColorNamed: "CurrencyHolderViewColor"))
    }
	
    internal weak var delegate: CurrencySelectionViewControllerDelegate?
    
    // MARK: Methods
    
    internal func setCurrencies(_ currencies: [AmountedCurrency], preselectedCurrency: AmountedCurrency) {
        
        self.dataManager = CurrencyCodesDataManager(currencies: currencies, preselectedCurrency: preselectedCurrency) { [weak self] in
            
            self?.tableView?.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
        
        self.selectCurrentSelectedCell()
    }
    
    internal override func requestToPop(_ decision: @escaping TypeAlias.BooleanClosure) {
        
        self.notifyDelegateIfCurrencyChanged()
        decision(true)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

       // self.paymentOptionsTableView?.reloadData()
        ThemeManager.shared.resetCurrentThemeToDefault()
        themeChanged()
        self.tableView?.reloadData()
        
    }
    
    internal override func tableViewLoaded(_ aTableView: UITableView) {
        
        super.tableViewLoaded(aTableView)
        self.selectCurrentSelectedCell()
    }
    
    internal override func searchViewTextChanged(_ text: String) {
        
        super.searchViewTextChanged(text)
        self.dataManager?.setFilter(text)
    }
	
	internal override func localizationChanged() {
		
		super.localizationChanged()
		self.dataManager?.updateLocalization()
	}
    
    // MARK: - Fileprivate -
    // MARK: Methods
    
    fileprivate func model(at indexPath: IndexPath) -> AmountedCurrencyTableViewCellModel {
        
        guard let model = self.dataManager?.filteredData[indexPath.row] else {
            
            fatalError("Data source is corrupted.")
        }
        
        return model
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private var dataManager: CurrencyCodesDataManager?
    
    // MARK: Methods
    
    private func selectCurrentSelectedCell() {
        
        guard let selectedIndexPath = self.dataManager?.selectedModelIndexPath else { return }
        guard selectedIndexPath.row < (self.tableView?.numberOfRows(inSection: 0) ?? 0) else { return }
        
        self.tableView?.selectRow(at: selectedIndexPath, animated: false, scrollPosition: .none)
    }
    
    private func notifyDelegateIfCurrencyChanged() {
        
        guard let manager = self.dataManager else { return }
        
        self.delegate?.currencySelectionViewControllerDidFinish(with: manager.selectedCurrency, changed: manager.hasCurrencyChanged)
    }
    
    private func revertDelegateCurrencyToPreselected() {
        
        guard let manager = self.dataManager else { return }
        
        self.delegate?.currencySelectionViewControllerDidFinish(with: manager.preselectedCurrency, changed: false)
    }
    
    @objc private func doneButtonTouchUpInside(_ sender: Any) {
        
        self.notifyDelegateIfCurrencyChangedAndPop()
    }
    
    @objc private func notifyDelegateIfCurrencyChangedAndPop() {
        
        performOnMainThread {
            
            self.notifyDelegateIfCurrencyChanged()
            self.pop()
        }
    }
}

// MARK: - TapNavigationView.DataSource
extension CurrencySelectionViewController: TapNavigationView.DataSource {
	
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
		
		return LocalizationManager.shared.localizedString(for: .currency_selection_screen_title)
	}
}

// MARK: - UITableViewDataSource
extension CurrencySelectionViewController: UITableViewDataSource {
    
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
extension CurrencySelectionViewController: UITableViewDelegate {
    
    internal func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let model = self.model(at: indexPath)
        
        model.updateCell()
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = self.model(at: indexPath)
        self.dataManager?.selectViewModel(model)
        
        self.notifyDelegateIfCurrencyChangedAndPop()
    }
}

// MARK: - InteractiveTransitionControllerDelegate
extension CurrencySelectionViewController: InteractiveTransitionControllerDelegate {
    
    internal func interactiveTransitionDidBegin() {
        
        self.notifyDelegateIfCurrencyChanged()
    }
    
    internal func interactiveTransitionDidCancel() {
        
        self.revertDelegateCurrencyToPreselected()
    }
}
