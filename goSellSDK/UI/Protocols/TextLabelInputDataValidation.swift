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
        
        let cardInputStyle	= Theme.current.paymentOptionsCellStyle.card.textInput
        let textSettings 	= self.isDataValid ? cardInputStyle.valid : cardInputStyle.invalid
        let textAttributes 	= textSettings.asStringAttributes
        
        self.labelField.attributedText = NSAttributedString(string: self.textInputFieldText, attributes: textAttributes)
        
        self.updateSpecificInputFieldAttributes()
    }
}
