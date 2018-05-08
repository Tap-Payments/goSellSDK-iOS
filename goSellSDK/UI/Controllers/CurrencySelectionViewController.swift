//
//  CurrencySelectionViewController.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKit.ClassProtocol
import class UIKit.UIImageView.UIImageView
import class UIKit.UILabel.UILabel
import class UIKit.UITableView.UITableView
import protocol UIKit.UITableView.UITableViewDataSource
import protocol UIKit.UITableView.UITableViewDelegate
import class UIKit.UITableViewCell.UITableViewCell

internal protocol CurrencySelectionViewControllerDelegate: ClassProtocol {
    
    func currencySelectionViewControllerDidFinish(with currency: AmountedCurrency)
}

internal class CurrencySelectionViewController: BaseViewController {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var delegate: CurrencySelectionViewControllerDelegate?
    
    // MARK: Methods
    
    internal func setCurrencies(_ currencies: [AmountedCurrency], preselectedCurrency: AmountedCurrency) {
        
        self.dataManager = CurrencyCodesDataManager(currencies: currencies, preselectedCurrency: preselectedCurrency) { [weak self] in
            
            self?.tableView?.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
        
        self.selectCurrentSelectedCell()
    }
    
    // MARK: - Fileprivate -
    // MARK: Methods
    
    fileprivate func model(at indexPath: IndexPath) -> AmountedCurrencyTableViewCellModel {
        
        guard let model = self.dataManager?.displayedViewModels[indexPath.row] else {
            
            fatalError("Data source is corrupted.")
        }
        
        return model
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var headerIconImageView: UIImageView?
    @IBOutlet private weak var headerTitleLabel: UILabel?
    @IBOutlet private weak var tableView: UITableView? {
        
        didSet {
            
            self.selectCurrentSelectedCell()
        }
    }
    
    private var dataManager: CurrencyCodesDataManager?
    
    // MARK: Methods
    
    @IBAction private func backButtonTouchUpInside(_ sender: Any) {
        
        self.notifyDelegateIfCurrencyChanged()
        
        DispatchQueue.main.async { [weak self] in
            
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    private func selectCurrentSelectedCell() {
        
        guard let selectedIndexPath = self.dataManager?.selectedModelIndexPath else { return }
        guard selectedIndexPath.row < (self.tableView?.numberOfRows(inSection: 0) ?? 0) else { return }
        
        self.tableView?.selectRow(at: selectedIndexPath, animated: false, scrollPosition: .none)
    }
    
    private func notifyDelegateIfCurrencyChanged() {
        
        guard let manager = self.dataManager, manager.hasCurrencyChanged else { return }
        
        self.delegate?.currencySelectionViewControllerDidFinish(with: manager.selectedCurrency)
    }
}

// MARK: - UITableViewDataSource
extension CurrencySelectionViewController: UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataManager?.displayedViewModels.count ?? 0
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
        model.tableViewDidSelectCell(tableView)
    }
    
    internal func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let model = self.model(at: indexPath)
        model.tableViewDidDeselectCell(tableView)
    }
}
