//
//  TextLabelInputDataValidation.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class UIKit.UILabel.UILabel

internal protocol TextLabelInputDataValidation: TextInputDataValidation {
    
    var labelField: UILabel { get }
}

internal extension TextLabelInputDataValidation {
    
    internal func updateInputFieldTextAndAttributes() {
        
        let cardInputSettings = Theme.current.settings.cardInputFieldsSettings
        let textSettings = self.isDataValid ? cardInputSettings.valid : cardInputSettings.invalid
        let textAttributes = textSettings.asStringAttributes
        
        self.labelField.attributedText = NSAttributedString(string: self.textInputFieldText, attributes: textAttributes)
        
        self.updateSpecificInputFieldAttributes()
    }
}
