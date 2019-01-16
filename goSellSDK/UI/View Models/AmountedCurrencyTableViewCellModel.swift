//
//  AmountedCurrencyTableViewCellModel.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class UIKit.UIImage.UIImage
import class UIKit.UITableView.UITableView

internal class AmountedCurrencyTableViewCellModel: TableViewCellViewModel {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var cell: AmountedCurrencyTableViewCell?
    
    internal let amountedCurrency: AmountedCurrency
	
    internal private(set) lazy var currencyNameText: String = .tap_empty
    
    internal private(set) lazy var amountText: String = .tap_empty
	
    internal var isSelected = false {
        
        didSet {
            
            self.updateCell(animated: true)
        }
    }
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal init(indexPath: IndexPath, amountedCurrency: AmountedCurrency) {
        
        self.amountedCurrency = amountedCurrency
		
        super.init(indexPath: indexPath)
		
		self.updateLocalization()
    }
	
	internal func updateLocalization() {
		
		self.currencyNameText	= self.amountedCurrency.readableCurrencyName
		self.amountText 		= self.amountedCurrency.displayValue
		
		self.updateCell(animated: false)
	}
	
	internal func updateTheme() {
		
		self.updateCell(animated: false)
	}
}

// MARK: - Filterable
extension AmountedCurrencyTableViewCellModel: Filterable {
    
    internal func matchesFilter(_ filterText: String) -> Bool {
        
        return self.currencyNameText.tap_containsIgnoringCase(filterText) || self.amountedCurrency.currency.isoCode.tap_containsIgnoringCase(filterText)
    }
}

// MARK: - SingleCellModel
extension AmountedCurrencyTableViewCellModel: SingleCellModel {}
