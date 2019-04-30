//
//  TextFieldInputDataValidation.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	TapBundleLocalization.LocalizationKey
import class	UIKit.UITextField.UITextField

internal protocol TextFieldInputDataValidation: TextInputDataValidation {
    
    var textInputField: UITextField { get }
    var textInputFieldPlaceholderText: LocalizationKey { get }
}

internal extension TextFieldInputDataValidation {
    
    func updateInputFieldTextAndAttributes() {
        
        let cardInputSettings = Theme.current.paymentOptionsCellStyle.card.textInput
		let textSettings = cardInputSettings[(self.isDataValid || self.textInputField.isEditing) ? .valid : .invalid]
		
		let textAttributes = textSettings.asStringAttributes
		
		#if swift(>=4.2)
		self.textInputField.defaultTextAttributes = textAttributes
		#else
		self.textInputField.defaultTextAttributes = textAttributes.tap_mapKeys { $0.rawValue }
		#endif
        
        let selectedRange = self.textInputField.selectedTextRange
        self.textInputField.attributedText = NSAttributedString(string: self.textInputFieldText, attributes: textAttributes)
        self.textInputField.selectedTextRange = selectedRange
        
        let placeholderAttributes = cardInputSettings[.placeholder].asStringAttributes
		let placeholderText = LocalizationManager.shared.localizedString(for: self.textInputFieldPlaceholderText)
		
        self.textInputField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: placeholderAttributes)
        
        self.updateSpecificInputFieldAttributes()
    }
}
