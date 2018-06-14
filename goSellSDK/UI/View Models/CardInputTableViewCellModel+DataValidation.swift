//
//  CardInputTableViewCellModel+DataValidation.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import enum TapCardValidator.CardBrand
import struct TapCardValidator.DefinedCardBrand
import class TapEditableView.TapEditableView
import class UIKit.UILabel.UILabel
import class UIKit.UIResponder.UIResponder
import class UIKit.UITextField.UITextField

internal extension CardInputTableViewCellModel {
    
    // MARK: - Internal -
    // MARK: Methods

    internal func bind(_ inputField: UIResponder?, displayLabel: UILabel?, editableView: TapEditableView? = nil, for validation: ValidationType) {
        
        var validator: CardValidator?
        
        switch validation {
            
        case .cardNumber:
            
            guard let textField = inputField as? UITextField else {
                
                fatalError("Card input field should be a text field.")
            }
            
            let v = CardNumberValidator(textField: textField,
                                        availableCardBrands: self.availableCardBrands,
                                        preferredCardBrands: self.preferredCardBrands)
            v.delegate = self
            v.brandReporting = self
            
            validator = v
            
        case .expirationDate:
            
            guard let textField = inputField as? UITextField else {
                
                fatalError("Expiration date input field should be a text field.")
            }
            
            guard let nonnullEditableView = editableView else {
                
                fatalError("Expiration date input field should have editable view on top.")
            }
            
            let v = ExpirationDateValidator(editableView: nonnullEditableView,
                                            textField: textField)
            
            v.delegate = self
            
            validator = v
        
        case .cvv:
            
            guard let textField = inputField as? UITextField else {
                
                fatalError("CVV input field should be a text field.")
            }
            
            let v = CVVValidator(textField: textField)
            v.delegate = self
            
            validator = v
            
        case .nameOnCard:
            
            guard let textField = inputField as? UITextField else {
                
                fatalError("Name on Card input field should be a text field.")
            }
            
            let v = CardholderNameValidator(textField: textField)
            v.delegate = self
            
            validator = v
            
        case .addressOnCard:
            
            guard let label = displayLabel else {
                
                fatalError("Address on Card requires a display label.")
            }
            
            let v = CardAddressValidator(displayLabel: label)
            v.delegate = self
            
            validator = v
        }
        
        if let existingValidatorIndex = self.cardDataValidators.index(where: { $0.validationType == validation }) {
            
            self.cardDataValidators.remove(at: existingValidatorIndex)
        }
        
        if let nonnullValidator = validator {
            
            self.cardDataValidators.append(nonnullValidator)
            
            self.updateValidatorWithInputData(nonnullValidator)
        }
    }
    
    internal func updateValidatorWithInputData(of type: ValidationType) {
        
        if let validator = self.validator(of: type) {
            
            self.updateValidatorWithInputData(validator)
        }
    }
    
    internal func validator(of type: ValidationType) -> CardValidator? {
        
        return self.cardDataValidators.first { $0.validationType == type }
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let binNumberLength = 6
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
    
    private var availableCardBrands: [CardBrand] {
        
        return self.paymentOptions.flatMap { $0.supportedCardBrands }
    }
    
    private var preferredCardBrands: [CardBrand] {
        
        return self.paymentOptions.map { $0.brand }
    }
    
    // MARK: Methods
    
    private func updateValidatorWithInputData(_ validator: CardValidator) {
        
        if let data = self.inputData[validator.validationType] {
            
            validator.update(with: data)
        }
        
        if let textFieldValidator = validator as? TextFieldInputDataValidation {
            
            textFieldValidator.updateInputFieldTextAndAttributes()
        }
        else if let labelValidator = validator as? TextLabelInputDataValidation {
            
            labelValidator.updateInputFieldTextAndAttributes()
        }
    }
    
    private func actualBinDataUpdated(_ newBINData: BINResponse?) {
        
        if self.binData != newBINData {
            
            self.binData = newBINData
        }
    }
}

// MARK: - CardValidatorDelegate
extension CardInputTableViewCellModel: CardValidatorDelegate {
    
    internal func cardValidator(_ validator: CardValidator, inputDataChanged data: Any?) {
        
        self.inputData[validator.validationType] = data
        
        if validator is TextLabelInputDataValidation {
            
            self.updateCell(animated: true)
        }
    }
    
    internal func validationStateChanged(to valid: Bool, on type: ValidationType) {
        
        PaymentDataManager.shared.updatePayButtonState()
    }
}

// MARK: - CardBrandChangeReporting
extension CardInputTableViewCellModel: CardBrandChangeReporting {
    
    internal func cardNumberValidator(_ validator: CardNumberValidator, cardNumberInputChanged cardNumber: String) {
        
        if cardNumber.length < Constants.binNumberLength {
            
            self.actualBinDataUpdated(nil)
            return
        }
        
        BINDataManager.shared.retrieveBINData(for: cardNumber.substring(to: Constants.binNumberLength)) { (response) in
            
            let inputCardNumber = validator.cardNumber
            let outputBINNumber = response.binNumber ?? .empty
            let inputTrimmedTo6Characters = inputCardNumber.length < Constants.binNumberLength ? .empty : inputCardNumber.substring(to: Constants.binNumberLength)
            let outputTrimmedTo6Characters = outputBINNumber.length < Constants.binNumberLength ? .empty : outputBINNumber.substring(to: Constants.binNumberLength)
            if inputTrimmedTo6Characters == outputTrimmedTo6Characters {
                
                self.actualBinDataUpdated(response)
            }
        }
    }
    
    internal func recognizedCardBrandChanged(_ definedCardBrand: DefinedCardBrand) {
        
        self.definedCardBrand = definedCardBrand
        
        if let cvvValidator = (self.cardDataValidators.first { $0.validationType == .cvv }) as? CVVValidator {
            
            cvvValidator.cardBrand = definedCardBrand.cardBrand
        }
        
        self.updateDisplayedCollectionViewCellModels()
    }
    
    internal func updateDisplayedCollectionViewCellModels() {
        
        if let existingBrand = self.definedCardBrand?.cardBrand {
            
            let possiblePaymentOptions = self.paymentOptions.filter {
                
                var allCardBrands: [CardBrand] = [$0.brand]
                allCardBrands.append(contentsOf: $0.supportedCardBrands)
                allCardBrands = Array(Set(allCardBrands))
                
                return allCardBrands.contains(existingBrand)
            }
            
            let possibleImageURLs = possiblePaymentOptions.map { $0.imageURL }
            let toBeDisplayedCellModels = self.tableViewCellModels.filter { possibleImageURLs.contains($0.imageURL) }
            
            self.displayedTableViewCellModels = toBeDisplayedCellModels
        }
        else {
            
            self.displayedTableViewCellModels = self.tableViewCellModels
        }
    }
}
