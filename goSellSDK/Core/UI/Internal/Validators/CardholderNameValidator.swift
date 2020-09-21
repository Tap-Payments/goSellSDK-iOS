//
//  CardholderNameValidator.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	TapBundleLocalization.LocalizationKey
import class	UIKit.UITextField.UITextField
import protocol	UIKit.UITextField.UITextFieldDelegate

/// Cardholder name validator.
internal class CardholderNameValidator: CardValidator {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal var cardholderName: String {
        
        return self.textField.attributedText?.string ?? .tap_empty
    }
    
    internal override var isValid: Bool {
        
        return self.cardholderName.tap_isValidCardholderName
    }
	
	internal override var errorCode: ErrorCode? {
		
		return self.isValid ? nil : .invalidCardholderName
	}
	
    // MARK: Methods
    
    internal init(textField: UITextField) {
        
        self.textField = textField
        
        super.init(validationType: .nameOnCard)
        
        self.setupTextField()
    }
    
    internal override func update(with inputData: Any?) {
        
        if let text = inputData as? String {
            self.textField.text = text
        }
        else {
            self.textField.text = nil
        }
        
        self.updateInputFieldTextAndAttributes()
        self.validate()
    }
    
    // MARK: - Private -
    
    private struct Constants {
		
        fileprivate static let maximalCardholderNameLength = 26
        fileprivate static let validCharactersRange = Constants.lowerBound...Constants.upperBound
        
        private static let lowerBound = "20".fromHex
        private static let upperBound = "5F".fromHex
        
        //@available(*, unavailable) private init() { }
    }
    
    // MARK: Properties
    
    private unowned let textField: UITextField
    
    private lazy var textFieldDelegate: CardholderNameTextFieldDelegate = CardholderNameTextFieldDelegate(validator: self)
    
    // MARK: Methods
    
    private func setupTextField() {
		
        self.textField.keyboardAppearance = Theme.current.commonStyle.keyboardAppearance.uiKeyboardAppearance
        self.textField.delegate = self.textFieldDelegate
        self.textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
    }
    
    @objc private func textFieldEditingChanged(_ sender: Any) {
        
        self.validate()
        
        self.delegate?.cardValidator(self, inputDataChanged: self.cardholderName)
        self.delegate?.validationStateChanged(to: self.isDataValid, on: .nameOnCard)
    }
}

// MARK: - TextFieldInputDataValidation
extension CardholderNameValidator: TextFieldInputDataValidation {
    
    internal var textInputField: UITextField {
        
        return self.textField
    }
    
    internal var textInputFieldText: String {
        
        return self.cardholderName
    }
    
    internal var textInputFieldPlaceholderText: LocalizationKey {
		
        return .card_input_cardholder_name_placeholder
    }
    
    internal func updateSpecificInputFieldAttributes() { }
}

// MARK: - CardholderNameTextFieldDelegate
fileprivate extension CardholderNameValidator {
    
    class CardholderNameTextFieldDelegate: NSObject {
        
        fileprivate init(validator: CardholderNameValidator) {
            
            self.validator = validator
            super.init()
        }
        
        private unowned let validator: CardholderNameValidator
    }
}

// MARK: - UITextFieldDelegate
extension CardholderNameValidator.CardholderNameTextFieldDelegate: UITextFieldDelegate {
    
    fileprivate func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		
        let resultString = (textField.attributedText?.string ?? .tap_empty).tap_replacing(range: range, withString: string).uppercased()
        
        var valid = true
        for character in resultString {
            
            if !CardholderNameValidator.Constants.validCharactersRange.contains(character) {
                
                valid = false
                break
            }
        }
        
        let canReplace = valid && resultString.tap_length <= CardholderNameValidator.Constants.maximalCardholderNameLength
        
        if canReplace {
            
            textField.attributedText = NSAttributedString(string: resultString, attributes: Theme.current.paymentOptionsCellStyle.card.textInput[.valid].asStringAttributes)
            
            if let rangeStart = textField.position(from: textField.beginningOfDocument, offset: range.location + string.tap_length),
               let rangeEnd = textField.position(from: rangeStart, offset: 0) {
                
                textField.selectedTextRange = textField.textRange(from: rangeStart, to: rangeEnd)
            }
            
            textField.sendActions(for: .editingChanged)
        }
        
        return false
    }
    
    fileprivate func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.validator.updateInputFieldTextAndAttributes()
        self.validator.validate()
    }
    
    fileprivate func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.validator.updateInputFieldTextAndAttributes()
        self.validator.validate()
    }
}

// MARK: - String + Hex
fileprivate extension String {
    
    var fromHex: Character {
        
        return Character(UnicodeScalar(Int(strtoul(self, nil, 16)))!)
    }
}
