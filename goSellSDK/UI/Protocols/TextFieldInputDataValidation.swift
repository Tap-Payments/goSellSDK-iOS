//
//  TextFieldInputDataValidation.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class UIKit.UITextField.UITextField

internal protocol TextFieldInputDataValidation: TextInputDataValidation {
    
    var textInputField: UITextField { get }
    var textInputFieldPlaceholderText: LocalizationKey { get }
}

internal extension TextFieldInputDataValidation {
    
    internal func updateInputFieldTextAndAttributes() {
        
        let cardInputSettings = Theme.current.paymentOptionsCellStyle.card.textInput
        let textSettings = self.isDataValid || self.textInputField.isEditing ? cardInputSettings.valid : cardInputSettings.invalid
        let textAttributes = textSettings.asStringAttributes
        
        self.textInputField.defaultTextAttributes = textAttributes
        
        let selectedRange = self.textInputField.selectedTextRange
        self.textInputField.attributedText = NSAttributedString(string: self.textInputFieldText, attributes: textAttributes)
        self.textInputField.selectedTextRange = selectedRange
        
        let placeholderAttributes = cardInputSettings.placeholder.asStringAttributes
		let placeholderText = LocalizationProvider.shared.localizedString(for: self.textInputFieldPlaceholderText)
		
        self.textInputField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: placeholderAttributes)
        
        self.updateSpecificInputFieldAttributes()
    }
}
