//
//  CardNumberValidator.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKitV2.ClassProtocol
import struct	TapBundleLocalization.LocalizationKey
import enum     TapCardVlidatorKit_iOS.CardBrand
import class    TapCardVlidatorKit_iOS.CardValidator
import struct   TapCardVlidatorKit_iOS.DefinedCardBrand
import class    UIKit.UITextField.UITextField
import protocol UIKit.UITextField.UITextFieldDelegate
import class    UIKit.UIView.UIView

/// Card Number Validator class.
internal class CardNumberValidator: CardValidator {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var brandReporting: CardBrandChangeReporting?
    
    internal var recognizedCardType: BrandWithScheme {
        
        let scheme = self.currentBINData?.scheme
        let localData = TapCardVlidatorKit_iOS.CardValidator.validate(cardNumber: self.cardNumber, preferredBrands: self.preferredCardBrands)
        let state = localData.validationState
        let brand = self.currentBINData?.cardBrand ?? localData.cardBrand ?? .unknown
        
        return BrandWithScheme(brand: brand, scheme: scheme, validationState: state)
    }
    
    internal var cardNumber: String {
        
        return self.textField.attributedText?.string ?? .tap_empty
    }
    
    internal override var isValid: Bool {
		
		guard let recognizedType = self.previousRecognizedType, recognizedType.validationState == .valid else { return false }
		
		if self.availableCardBrands.contains(recognizedType.brand) { return true }
		if let schemeBrand = recognizedType.scheme?.cardBrand {
			
			return self.availableCardBrands.contains(schemeBrand)
		}
		else {
			
			return false
		}
    }
	
	internal override var errorCode: ErrorCode? {
		
		guard let recognizedType = self.previousRecognizedType, recognizedType.validationState == .valid else { return .invalidCardNumber }
		
		if self.availableCardBrands.contains(recognizedType.brand) { return nil }
		if let schemeBrand = recognizedType.scheme?.cardBrand, self.availableCardBrands.contains(schemeBrand) { return nil }
		
		return .unsupportedCard
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
        
        self.compareNewRecognizedBrandToPreviousAndCallDelegate(self.recognizedCardType, number: self.cardNumber)
        
        self.updateInputFieldTextAndAttributes()
    }
    
    internal func update(withRemoteBINData binData: BINResponse?) {
        
        self.currentBINData = binData
        self.inputDataChanged()
    }
    
    internal override func validate() {
        
        let recognizedBrand = self.recognizedCardType
        
        self.compareNewRecognizedBrandToPreviousAndCallDelegate(recognizedBrand, number: self.cardNumber)
        
        self.updateInputFieldTextAndAttributes()
        
        super.validate()
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private unowned var textField: UITextField
    
    private lazy var textFieldDelegate = CardNumberTextFieldDelegate(validator: self)
    
    private var availableCardBrands: [CardBrand]
    private var preferredCardBrands: [CardBrand]
    
    private var previousRecognizedType: BrandWithScheme?
    private var previousCardNumber: String?
    
    private var currentBINData: BINResponse?
    
    // MARK: Methods
    
    private func setupTextField() {
		
		self.textField.keyboardAppearance = Theme.current.commonStyle.keyboardAppearance.uiKeyboardAppearance
		
        if #available(iOS 10.0, *) {
            
            self.textField.keyboardType = .asciiCapableNumberPad
            self.textField.textContentType = .creditCardNumber

        } else {
            
            self.textField.keyboardType = .numberPad
        }
        
        self.textField.delegate = self.textFieldDelegate
        self.textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
    }
    
    @objc private func textFieldEditingChanged(_ sender: Any) {
        
        self.inputDataChanged()
    }
    
    private func inputDataChanged() {
        
        let recognizedType = self.recognizedCardType
        let cardBrand = recognizedType.brand
        
        self.setupSpacingsAndOptionallyTrimText(for: cardBrand)
        
        self.delegate?.cardValidator(self, inputDataChanged: self.cardNumber)
        self.compareNewRecognizedBrandToPreviousAndCallDelegate(recognizedType, number: self.cardNumber)
        self.delegate?.validationStateChanged(to: self.isDataValid, on: .cardNumber)
    }
    
    private func compareNewRecognizedBrandToPreviousAndCallDelegate(_ type: BrandWithScheme, number: String) {
        
        var shouldCallDelegateWithNewType: Bool
        
        if let nonnullPreviousType = self.previousRecognizedType {
        
            shouldCallDelegateWithNewType = nonnullPreviousType != type
        }
        else {
            
            shouldCallDelegateWithNewType = true
        }

        if shouldCallDelegateWithNewType {
            
            self.previousRecognizedType = type
            self.brandReporting?.recognizedCardBrandChanged(type)
        }
        
        var shouldCallDelegateWithNewCardNumber: Bool
        if let nonnullPreviousNumber = self.previousCardNumber {
            
            shouldCallDelegateWithNewCardNumber = nonnullPreviousNumber != number
        }
        else {
            
            shouldCallDelegateWithNewCardNumber = true
        }
        
        if shouldCallDelegateWithNewCardNumber {
            
            self.previousCardNumber = number
            self.brandReporting?.cardNumberValidator(self, cardNumberInputChanged: number)
        }
    }
    
    private func setupSpacingsAndOptionallyTrimText(for brand: CardBrand?) {
        
        UIView.performWithoutAnimation {
            
            let cardBrand = brand ?? self.recognizedCardType.brand
            
            let attributedText = self.textField.attributedText ?? NSAttributedString(string: .tap_empty, attributes: Theme.current.paymentOptionsCellStyle.card.textInput[.valid].asStringAttributes)
			
			var text: NSAttributedString
			if cardBrand == .unknown {
				
				text = attributedText
			}
			else {
			
            	let trimRange = NSRange(location: 0, length: min(attributedText.length, TapCardVlidatorKit_iOS.CardValidator.maximalCardNumberLength(for: cardBrand)))
            	text = attributedText.attributedSubstring(from: trimRange)
			}
			
            let selectedRange = self.textField.selectedTextRange

            self.textField.attributedText = self.applySpacings(for: text, cardBrand: cardBrand)
            self.textField.selectedTextRange = selectedRange
        }
    }
    
    private func applySpacings(for attributedString: NSAttributedString, cardBrand: CardBrand? = nil) -> NSAttributedString {
        
        let stringLength = attributedString.length
        guard stringLength > 0 else { return attributedString }
        
        let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
        
        let spacings = TapCardVlidatorKit_iOS.CardValidator.spacings(for: cardBrand)
        let adoptedSpacings = self.adoptSpacings(from: spacings, cardNumberLength: stringLength)
        
        for index in 0..<stringLength {
            
            let kerningValue = adoptedSpacings.contains(index) ? 5 : 0
            let range =  NSRange(location: index, length: 1)
            
            mutableAttributedString.addAttribute(.kern, value: kerningValue, range: range)
        }
        
        return NSAttributedString(attributedString: mutableAttributedString)
    }
    
    private func adoptSpacings(from spacings: [Int], cardNumberLength: Int) -> [Int] {
        
        return spacings.filter { $0 + 1 < cardNumberLength }
    }
}

// MARK: - TextFieldInputDataValidation
extension CardNumberValidator: TextFieldInputDataValidation {
    
    internal var textInputField: UITextField {
        
        return self.textField
    }
    
    internal var textInputFieldText: String {
        
        return self.cardNumber
    }
    
    internal var textInputFieldPlaceholderText: LocalizationKey {
        
        return .card_input_card_number_placeholder
    }
    
    internal func updateSpecificInputFieldAttributes() {
        
        if let previousType = self.previousRecognizedType {
            
            self.setupSpacingsAndOptionallyTrimText(for: previousType.brand)
        }
    }
}

// MARK: - CardNumberTextFieldDelegate
fileprivate extension CardNumberValidator {
    
    class CardNumberTextFieldDelegate: NSObject {
        
        fileprivate init(validator: CardNumberValidator) {
            
            self.validator = validator
        }
        
        fileprivate unowned let validator: CardNumberValidator
    }
}

// MARK: - UITextFieldDelegate
extension CardNumberValidator.CardNumberTextFieldDelegate: UITextFieldDelegate {
    
    fileprivate func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let desiredText = textField.attributedText?.string.tap_replacing(range: range, withString: string) ?? .tap_empty
        let numberOnlyText = desiredText.trimmingCharacters(in: .whitespaces)
        
        return numberOnlyText.tap_containsOnlyInternationalDigits
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
