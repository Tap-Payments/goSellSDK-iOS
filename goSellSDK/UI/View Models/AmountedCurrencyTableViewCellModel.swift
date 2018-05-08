//
//  AmountedCurrencyTableViewCellModel.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class UIKit.UITableView.UITableView

internal class AmountedCurrencyTableViewCellModel: CellViewModel {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var cell: AmountedCurrencyTableViewCell?
    
    internal let amountedCurrency: AmountedCurrency
    
    internal let currencyNameText: String
    
    internal let amountText: String
    
    internal var isSelected = false {
        
        didSet {
            
            self.updateCell(animated: true)
        }
    }
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal init(indexPath: IndexPath, amountedCurrency: AmountedCurrency) {
        
        self.amountedCurrency = amountedCurrency
        self.currencyNameText = amountedCurrency.readableCurrencyName
        self.amountText = amountedCurrency.displayValue
        
        super.init(indexPath: indexPath)
    }
    
    internal override func tableViewDidSelectCell(_ sender: UITableView) {
        
        self.isSelected = true
    }
    
    internal override func tableViewDidDeselectCell(_ sender: UITableView) {
        
        self.isSelected = false
    }
}

// MARK: - SingleCellModel
extension AmountedCurrencyTableViewCellModel: SingleCellModel {}
