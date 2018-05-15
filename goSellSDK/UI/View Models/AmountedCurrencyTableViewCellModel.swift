//
//  AmountedCurrencyTableViewCellModel.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class UIKit.UIImage.UIImage
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
    
    internal var checkmarkImage: UIImage {
        
        return Theme.current.settings.generalImages.checkmarkImage
    }
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal init(indexPath: IndexPath, amountedCurrency: AmountedCurrency) {
        
        self.amountedCurrency = amountedCurrency
        self.currencyNameText = amountedCurrency.readableCurrencyName
        self.amountText = amountedCurrency.displayValue
        
        super.init(indexPath: indexPath)
    }
}

// MARK: - Filterable
extension AmountedCurrencyTableViewCellModel: Filterable {
    
    internal func matchesFilter(_ filterText: String) -> Bool {
        
        return self.currencyNameText.containsIgnoringCase(filterText) || self.amountedCurrency.currency.isoCode.containsIgnoringCase(filterText)
    }
}

// MARK: - SingleCellModel
extension AmountedCurrencyTableViewCellModel: SingleCellModel {}
