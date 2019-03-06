//
//  CurrencySelectionTableViewCellViewModel.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class UIKit.UIImage.UIImage
import class UIKit.UITableView.UITableView

/// View model for currency selection
internal class CurrencySelectionTableViewCellViewModel: TableViewCellViewModel {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Transaction currency
    internal let transactionCurrency: AmountedCurrency
    
    /// User selected currency
    internal var userSelectedCurrency: AmountedCurrency {
        
        didSet {
            
            self.updateDisplayedTexts(updateContent: true)
        }
    }
    
    internal var billImage: UIImage {
		
		return Theme.current.paymentOptionsCellStyle.currency.billIcon
    }
    
    internal var arrowImage: UIImage {
		
		return Theme.current.commonStyle.icons.arrowRight
    }
    
    internal weak var cell: CurrencySelectionTableViewCell?
    
    internal private(set) var displayedTransactionCurrencyText: String?
    internal private(set) var displayedUserCurrencyText: String?
    
    internal override var indexPathOfCellToSelect: IndexPath? {
        
        return self.indexPath
    }
    
    // MARK: Methods
    
    internal init(indexPath: IndexPath, transactionCurrency: AmountedCurrency, userSelectedCurrency: AmountedCurrency) {
        
        self.transactionCurrency = transactionCurrency
        self.userSelectedCurrency = userSelectedCurrency
        super.init(indexPath: indexPath)
        
        self.updateDisplayedTexts()
    }
    
    internal override func tableViewDidSelectCell(_ sender: UITableView) {
        
        super.tableViewDidSelectCell(sender)
    }
    
    // MARK: - Private -
    // MARK: Methods
    
    private func updateDisplayedTexts(updateContent: Bool = false) {
        
        self.displayedTransactionCurrencyText = self.transactionCurrency == self.userSelectedCurrency ? .tap_empty : self.transactionCurrency.displayValue
        self.displayedUserCurrencyText = self.userSelectedCurrency.displayValue
        
        if updateContent {
            
            self.updateCell(animated: true)
        }
    }
}

// MARK: - SingleCellModel
extension CurrencySelectionTableViewCellViewModel: SingleCellModel {}
