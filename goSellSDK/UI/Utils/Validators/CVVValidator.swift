//
//  CVVValidator.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKit.ClassProtocol
import enum TapCardValidator.CardBrand
import class TapCardValidator.CardValidator

/// CVV validator.
internal class CVVValidator: CardValidator {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Card brand.
    internal var cardBrand: CardBrand?
    
    /// CVV code.
    internal var cvv: String {
        
        return self.textField.attributedText?.string ?? .empty
    }
    
    internal override var isValid: Bool {
    
        return self.cvv.length == self.requiredCVVLength
    }
    
    // MARK: Methods
    
    internal init(textField: UITextField) {
        
        self.textField = textField
        super.init(validationType: .cvv)
        
        self.setupTextField()
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private unowned let textField: UITextField
    
    private lazy var textFieldDelegate: CVVTextFieldDelegate = CVVTextFieldDelegate(validator: self)
    
    fileprivate var requiredCVVLength: Int {
        
        return TapCardValidator.CardValidator.cvvLength(for: self.cardBrand)
    }
    
    // MARK: Methods
    
    private func setupTextField() {
        
        if #available(iOS 10.0, *) {
            
            self.textField.keyboardType = .asciiCapableNumberPad
        } else {
            
            self.textField.keyboardType = .numberPad
        }
        
        self.textField.keyboardAppearance = Theme.current.settings.keyboardStyle
        self.textField.delegate = self.textFieldDelegate
        self.textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
//        self.setupPlaceholder()
    }
    
    @objc private func textFieldEditingChanged(_ sender: Any) {
        
        self.validate()
    }
    
//    private func setupPlaceholder() {
//
//        self.textField.attributedPlaceholder = NSAttributedString(string: "CVV", attributes: Theme.current.settings.cardInputFieldsSettings.placeholder.asStringAttributes)
//    }
}

// MARK: - TextInputDataValidation
extension CVVValidator: TextInputDataValidation {
    
    internal var textInputField: UITextField {
        
        return self.textField
    }
    
    internal var textInputFieldText: String {
        
        return self.cvv
    }
    
    internal var textInputFieldPlaceholderText: String {
        
        return "CVV"
    }
    
    internal func updateSpecificInputFieldAttributes() { }
}

// MARK: - CVVTextFieldDelegate
fileprivate extension CVVValidator {
    
    fileprivate class CVVTextFieldDelegate: NSObject {
        
        fileprivate init(validator: CVVValidator) {
            
            self.validator = validator
            super.init()
        }
        
        private unowned let validator: CVVValidator
    }
}

// MARK: - UITextFieldDelegate
extension CVVValidator.CVVTextFieldDelegate: UITextFieldDelegate {
    
    fileprivate func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let resultString = (textField.attributedText?.string ?? String.empty).replacing(range: range, withString: string)
        return resultString.containsOnlyInternationalDigits && Int(resultString.length) <= self.validator.requiredCVVLength
    }
    
    fileprivate func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.attributedText = NSAttributedString(string: .empty, attributes: Theme.current.settings.cardInputFieldsSettings.valid.asStringAttributes)
        
        self.validator.updateInputFieldAttributes()
        self.validator.validate()
    }
    
    fileprivate func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.validator.updateInputFieldAttributes()
        self.validator.validate()
    }
}
