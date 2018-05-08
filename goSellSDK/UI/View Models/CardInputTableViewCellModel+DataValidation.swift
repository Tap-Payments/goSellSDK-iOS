//
//  CardInputTableViewCellModel+DataValidation.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import enum TapCardValidator.CardBrand
import struct TapCardValidator.DefinedCardBrand
import class TapEditableView.TapEditableView

internal extension CardInputTableViewCellModel {
    
    // MARK: - Internal -
    // MARK: Methods

    internal func bind(_ inputField: UIResponder, editableView: TapEditableView? = nil, for validation: ValidationType) {
        
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
        }
        
        if let existingValidatorIndex = self.cardDataValidators.index(where: { $0.validationType == validation }) {
            
            self.cardDataValidators.remove(at: existingValidatorIndex)
        }
        
        if let nonnullValidator = validator {
            
            self.cardDataValidators.append(nonnullValidator)
            
            if let data = self.inputData[nonnullValidator.validationType] {
                
                nonnullValidator.update(with: data)
            }
            
            if let textFieldValidator = nonnullValidator as? TextInputDataValidation {
                
                textFieldValidator.updateInputFieldAttributes()
            }
        }
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private var availableCardBrands: [CardBrand] {
        
        return self.paymentOptions.flatMap { $0.supportedCardBrands }
    }
    
    private var preferredCardBrands: [CardBrand] {
        
        return self.paymentOptions.map { $0.name }
    }
}

// MARK: - CardValidatorDelegate
extension CardInputTableViewCellModel: CardValidatorDelegate {
    
    internal func cardValidator(_ validator: CardValidator, inputDataChanged data: Any?) {
        
        self.inputData[validator.validationType] = data
    }
    
    
    internal func validationStateChanged(to valid: Bool, on type: ValidationType) {
        
    }
}

// MARK: - CardBrandChangeReporting
extension CardInputTableViewCellModel: CardBrandChangeReporting {
    
    internal func recognizedCardBrandChanged(_ definedCardBrand: DefinedCardBrand) {
        
        self.definedCardBrand = definedCardBrand
        
        NSLog("Current recognized brand: \(definedCardBrand.cardBrand?.rawValue ?? "nil")")
        
        self.updateDisplayedCollectionViewCellModels()
        
        if let cvvValidator = (self.cardDataValidators.first { $0.validationType == .cvv }) as? CVVValidator {
            
            cvvValidator.cardBrand = definedCardBrand.cardBrand
        }
    }
    
    internal func updateDisplayedCollectionViewCellModels() {
        
        if let existingBrand = self.definedCardBrand?.cardBrand {
            
            let possiblePaymentOptions = self.paymentOptions.filter {
                
                var allCardBrands: [CardBrand] = [$0.name]
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
