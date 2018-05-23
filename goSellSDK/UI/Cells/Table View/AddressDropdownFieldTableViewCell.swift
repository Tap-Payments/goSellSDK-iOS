//
//  AddressDropdownFieldTableViewCell.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class UIKit.UIImageView.UIImageView
import class UIKit.UILabel.UILabel

internal class AddressDropdownFieldTableViewCell: AddressFieldTableViewCell {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var model: AddressDropdownFieldTableViewCellModel?
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var selectedValueLabel: UILabel?
    
    @IBOutlet private weak var arrowImageView: UIImageView?
}

// MARK: - LoadingWithModelCell
extension AddressDropdownFieldTableViewCell: LoadingWithModelCell {
    
    internal func updateContent(animated: Bool) {
        
        self.updateDescription(self.model?.descriptionText, width: self.model?.descriptionWidth ?? 0.0)
        self.selectedValueLabel?.text = self.model?.preselectedValueText
        self.arrowImageView?.image = self.model?.arrowImage
    }
}
