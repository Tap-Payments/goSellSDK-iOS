//
//  CardNumberValidator.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKit.ClassProtocol
import enum TapCardValidator.CardBrand
import class TapCardValidator.CardValidator
import struct TapCardValidator.DefinedCardBrand
import class UIKit.UITextField.UITextField
import protocol UIKit.UITextField.UITextFieldDelegate
import class UIKit.UIView.UIView

internal protocol CardBrandChangeReporting: ClassProtocol {
    
    func recognizedCardBrandChanged(_ definedCardBrand: DefinedCardBrand)
}

/// Card Number Validator class.
internal class CardNumberValidator: CardValidator {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var brandReporting: CardBrandChangeReporting?
    
    internal var recognizedCardType: DefinedCardBrand {
        
        return TapCardValidator.CardValidator.validate(cardNumber: self.cardNumber, preferredBrands: self.preferredCardBrands)
    }
    
    internal var cardNumber: String {
        
        return self.textField.attributedText?.string ?? .empty
    }
    
    internal override var isValid: Bool {
        
        if let validationState = self.previousRecognizedType?.validationState {
            
            return validationState == .valid
        }
        else {
            
            return false
        }
    }
    
    // MARK: Methods
    
    internal init(textField: UITextField, availableCardBrands: [CardBrand], preferredCardBrands: [CardBrand]) {
        
        self.textField = textField
        self.availableCardBrands = availableCardBrands
        self.preferredCardBrands = preferredCardBrands
        
        super.init(validationType: .cardNumber)
        
        self.setupTextField()
    }
    
    internal override func update(with inputData: Any?) {
        
        if let text = inputData as? String {
            
            self.textField.text = text
        }
        else {
            
            self.textField.text = nil
        }
        
        self.updateInputFieldAttributes()
    }
    
    internal override func validate() {
        
        let recognizedBrand = self.recognizedCardType
        
        self.compareNewRecognizedBrandToPrevoiusAndCallDelegate(recognizedBrand)
        
        self.updateInputFieldAttributes()
        
        super.validate()
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private unowned var textField: UITextField
    
    private lazy var textFieldDelegate = CardNumberTextFieldDelegate(validator: self)
    
    private var availableCardBrands: [CardBrand]
    private var preferredCardBrands: [CardBrand]
    
    private var previousRecognizedType: DefinedCardBrand?
    
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
    }
    
    @objc private func textFieldEditingChanged(_ sender: Any) {
        
        let recognizedType = self.recognizedCardType
        defer {
            
            self.delegate?.cardValidator(self, inputDataChanged: self.cardNumber)
            self.compareNewRecognizedBrandToPrevoiusAndCallDelegate(recognizedType)
        }
        
        let cardBrand = recognizedType.cardBrand
        self.setupSpacings(for: cardBrand)
    }
    
    private func compareNewRecognizedBrandToPrevoiusAndCallDelegate(_ type: DefinedCardBrand) {
        
        defer {
            
            self.previousRecognizedType = type
        }
        
        var shouldCallDelegate: Bool
        
        if let nonnullPreviousType = self.previousRecognizedType {
            
            shouldCallDelegate = nonnullPreviousType != type
        }
        else {
            
            shouldCallDelegate = true
        }

        if shouldCallDelegate {
            
            self.brandReporting?.recognizedCardBrandChanged(type)
        }
    }
    
    private func setupSpacings(for brand: CardBrand?) {
        
        UIView.performWithoutAnimation {
            
            let cardBrand = brand ?? ( self.recognizedCardType.cardBrand ?? .unknown )
            let attributedText = self.textField.attributedText ?? NSAttributedString(string: .empty, attributes: Theme.current.settings.cardInputFieldsSettings.valid.asStringAttributes)
            
            let selectedRange = self.textField.selectedTextRange
            self.textField.attributedText = self.applySpacings(for: attributedText, cardBrand: cardBrand)
            self.textField.selectedTextRange = selectedRange
        }
    }
    
    private func applySpacings(for attributedString: NSAttributedString, cardBrand: CardBrand? = nil) -> NSAttributedString {
        
        guard attributedString.length > 0 else { return attributedString }
        
        let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
        
        let spacings = TapCardValidator.CardValidator.spacings(for: cardBrand)
        for index in 0..<mutableAttributedString.length {
            
            if spacings.contains(index) {
                
                mutableAttributedString.addAttribute(.kern, value: 5, range: NSRange(location: index, length: 1))
            }
            else {
                
                mutableAttributedString.addAttribute(.kern, value: 0, range: NSRange(location: index, length: 1))
            }
        }
        
        return NSAttributedString(attributedString: mutableAttributedString)
    }
}

// MARK: - TextInputDataValidation
extension CardNumberValidator: TextInputDataValidation {
    
    internal var textInputField: UITextField {
        
        return self.textField
    }
    
    internal var textInputFieldText: String {
        
        return self.cardNumber
    }
    
    internal var textInputFieldPlaceholderText: String {
        
        return "Card Number"
    }
    
    internal func updateSpecificInputFieldAttributes() {
        
        if let previousType = self.previousRecognizedType {
            
            self.setupSpacings(for: previousType.cardBrand)
        }
    }
}

// MARK: - CardNumberTextFieldDelegate
fileprivate extension CardNumberValidator {
    
    fileprivate class CardNumberTextFieldDelegate: NSObject {
        
        fileprivate init(validator: CardNumberValidator) {
            
            self.validator = validator
        }
        
        fileprivate unowned let validator: CardNumberValidator
    }
}

// MARK: - UITextFieldDelegate
extension CardNumberValidator.CardNumberTextFieldDelegate: UITextFieldDelegate {
    
    fileprivate func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let desiredText = textField.attributedText?.string.replacing(range: range, withString: string) ?? .empty
        let numberOnlyText = desiredText.trimmingCharacters(in: .whitespaces)
        
        return numberOnlyText.containsOnlyInternationalDigits
    }
    
    fileprivate func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.validator.updateInputFieldAttributes()
        self.validator.validate()
    }
    
    fileprivate func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.validator.updateInputFieldAttributes()
        self.validator.validate()
    }
}
