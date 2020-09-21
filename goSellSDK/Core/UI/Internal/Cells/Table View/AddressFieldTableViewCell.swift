//
//  AddressFieldTableViewCell.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import class UIKit.NSLayoutConstraint.NSLayoutConstraint
import class UIKit.UILabel.UILabel

/// Cell to display address field.
internal class AddressFieldTableViewCell: BaseTableViewCell {
    
    // MARK: - Internal -
    // MARK: Methods
    
    /// Updates `descriptionLabel` with `descriptionText` and sets width costraint value to `width`.
    ///
    /// - Parameters:
    ///   - descriptionText: Text to update `descriptionLabel` with.
    ///   - width: Width to update `descriptionLabel` with.
    internal func updateDescription(_ descriptionText: String?, width: CGFloat) {
        
        self.descriptionLabel?.text = descriptionText
        self.descriptionLabelWidthConstraint?.constant = width
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var descriptionLabel: UILabel?
    @IBOutlet private weak var descriptionLabelWidthConstraint: NSLayoutConstraint?
}
