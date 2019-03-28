//
//  TextLabelInputDataValidation.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class UIKit.UILabel.UILabel

internal protocol TextLabelInputDataValidation: TextInputDataValidation {
    
    var labelField: UILabel { get }
}

internal extension TextLabelInputDataValidation {
    
    func updateInputFieldTextAndAttributes() {
        
        let cardInputStyle	= Theme.current.paymentOptionsCellStyle.card.textInput
		let textSettings 	= cardInputStyle[self.isDataValid ? .valid : .invalid]
        let textAttributes 	= textSettings.asStringAttributes
        
        self.labelField.attributedText = NSAttributedString(string: self.textInputFieldText, attributes: textAttributes)
        
        self.updateSpecificInputFieldAttributes()
    }
}
