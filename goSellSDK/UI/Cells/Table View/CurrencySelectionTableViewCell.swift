//
//  CurrencySelectionTableViewCell.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Cell for currency selection.
internal class CurrencySelectionTableViewCell: BaseTableViewCell {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var model: CurrencySelectionTableViewCellViewModel?
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private var onePixelConstraints: [NSLayoutConstraint]? {
        
        didSet {
            
            let value = UIScreen.main.numberOfPointsInOnePixel
            self.onePixelConstraints?.forEach { $0.constant = value }
        }
    }
    
    @IBOutlet private weak var transactionCurrencyLabel: UILabel?
    @IBOutlet private weak var userSelectedCurrencyLabel: UILabel?
}

// MARK: - LoadingWithModelCell
extension CurrencySelectionTableViewCell: LoadingWithModelCell {
    
    internal func updateContent(animated: Bool) {
        
        self.transactionCurrencyLabel?.text = self.model?.displayedTransactionCurrencyText
        self.userSelectedCurrencyLabel?.text = self.model?.displayedUserCurrencyText
    }
    
    
    
}
