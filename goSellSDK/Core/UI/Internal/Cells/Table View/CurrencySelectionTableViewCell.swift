//
//  CurrencySelectionTableViewCell.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class UIKit.UIImageView.UIImageView
import class UIKit.UILabel.UILabel

/// Cell for currency selection.
internal class CurrencySelectionTableViewCell: BaseTableViewCell {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var model: CurrencySelectionTableViewCellViewModel?
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var transactionCurrencyLabel: UILabel?
    @IBOutlet private weak var userSelectedCurrencyLabel: UILabel?
    @IBOutlet private weak var billImageView: UIImageView?
    @IBOutlet private weak var arrowImageView: UIImageView?
}

// MARK: - LoadingWithModelCell
extension CurrencySelectionTableViewCell: LoadingWithModelCell {
    
    internal func updateContent(animated: Bool) {
		
		let style = Theme.current.paymentOptionsCellStyle.currency
		
        self.transactionCurrencyLabel?.text		= self.model?.displayedTransactionCurrencyText
		self.transactionCurrencyLabel?.setTextStyle(style.transactionCurrencyTextStyle)
		
        self.userSelectedCurrencyLabel?.text	= self.model?.displayedUserCurrencyText
		self.userSelectedCurrencyLabel?.setTextStyle(style.selectedCurrencyTextStyle)
		
        self.billImageView?.image 	= self.model?.billImage
        self.arrowImageView?.image	= self.model?.arrowImage
    }
}
