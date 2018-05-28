//
//  TaxTableViewCell.swift
//  goSellSDKExample
//
//  Created by Dennis Pashkov on 5/25/18.
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class UIKit.UILabel.UILabel
import class UIKit.UITableViewCell.UITableViewCell

internal class TaxTableViewCell: UITableViewCell {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal func setTitle(_ title: String?, descriptionText: String?, valueText: String?) {
        
        self.titleTextLabel?.text = title
        self.descriptionTextLabel?.text = descriptionText
        self.valueLabel?.text = valueText
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var titleTextLabel: UILabel?
    @IBOutlet private weak var descriptionTextLabel: UILabel?
    @IBOutlet private weak var valueLabel: UILabel?
}
