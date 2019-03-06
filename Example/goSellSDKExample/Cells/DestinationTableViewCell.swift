//
//  DestinationTableViewCell.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	UIKit.UILabel.UILabel
import class	UIKit.UITableViewCell.UITableViewCell

internal final class DestinationTableViewCell: UITableViewCell {
	
	// MARK: - Internal -
	// MARK: Methods
	
	internal func setIdentifier(_ identifier: String, amount: String, currency: String) {
		
		self.identiferLabel?.text = identifier
		self.amountLabel?.text = amount
		self.currencyLabel?.text = currency
	}
	
	// MARK: - Private -
	// MARK: Properties
	
	@IBOutlet private weak var identiferLabel: UILabel?
	@IBOutlet private weak var amountLabel: UILabel?
	@IBOutlet private weak var currencyLabel: UILabel?
}
