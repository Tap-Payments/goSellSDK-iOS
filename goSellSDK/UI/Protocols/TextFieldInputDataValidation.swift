//
//  TextFieldInputDataValidation.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class UIKit.UITextField.UITextField

internal protocol TextFieldInputDataValidation: TextInputDataValidation {
    
    var textInputField: UITextField { get }
    var textInputFieldPlaceholderText: String { get }
}

internal extension TextFieldInputDataValidation {
    
    internal func updateInputFieldTextAndAttributes() {
        
        let cardInputSettings = Theme.current.settings.cardInputFieldsSettings
        let textSettings = self.isDataValid || self.textInputField.isEditing ? cardInputSettings.valid : cardInputSettings.invalid
        let textAttributes = textSettings.asStringAttributes
        
        self.textInputField.defaultTextAttributes = textAttributes.mapKeys { $0.rawValue }
        
        let selectedRange = self.textInputField.selectedTextRange
        self.textInputField.attributedText = NSAttributedString(string: self.textInputFieldText, attributes: textAttributes)
        self.textInputField.selectedTextRange = selectedRange
        
        let placeholderAttributes = cardInputSettings.placeholder.asStringAttributes
        self.textInputField.attributedPlaceholder = NSAttributedString(string: self.textInputFieldPlaceholderText, attributes: placeholderAttributes)
        
        self.updateSpecificInputFieldAttributes()
    }
}
