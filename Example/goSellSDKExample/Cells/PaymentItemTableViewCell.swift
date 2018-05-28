//
//  PaymentItemTableViewCell.swift
//  goSellSDKExample
//
//  Created by Dennis Pashkov on 5/25/18.
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class UIKit.UILabel.UILabel
import class UIKit.UITableViewCell.UITableViewCell

internal class PaymentItemTableViewCell: UITableViewCell {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal func setTitle(_ title: String, quantityValue: String, quantityMeasurement: String, price: String, amount: String, discount: String, taxes: String, total: String) {
        
        self.titleTextLabel?.text = title
        self.quantityValueLabel?.text = quantityValue
        self.quantityMeasurementLabel?.text = quantityMeasurement
        self.priceLabel?.text = price
        self.amountLabel?.text = amount
        self.discountLabel?.text = discount
        self.taxesLabel?.text = taxes
        self.totalAmountLabel?.text = total
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var titleTextLabel: UILabel?
    @IBOutlet private weak var quantityValueLabel: UILabel?
    @IBOutlet private weak var quantityMeasurementLabel: UILabel?
    @IBOutlet private weak var priceLabel: UILabel?
    @IBOutlet private weak var amountLabel: UILabel?
    @IBOutlet private weak var discountLabel: UILabel?
    @IBOutlet private weak var taxesLabel: UILabel?
    @IBOutlet private weak var totalAmountLabel: UILabel?
}
