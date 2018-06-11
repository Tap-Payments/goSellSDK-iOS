//
//  ShippingTableViewCell.swift
//  goSellSDKExample
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class UIKit.UILabel.UILabel
import class UIKit.UITableViewCell.UITableViewCell

internal final class ShippingTableViewCell: UITableViewCell {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal func setTitleText(_ titleText: String, amountText: String) {
        
        self.titleLabel?.text = titleText
        self.amountLabel?.text = amountText
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var amountLabel: UILabel?
}
