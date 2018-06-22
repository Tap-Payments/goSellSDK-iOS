//
//  CardInputTableViewCellModel+DataValidation.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import enum     TapCardValidator.CardBrand
import struct   TapCardValidator.DefinedCardBrand
import class    TapEditableView.TapEditableView
import class    UIKit.UILabel.UILabel
import class    UIKit.UIResponder.UIResponder
import class    UIKit.UISwitch.UISwitch
import class    UIKit.UITextField.UITextField

internal extension CardInputTableViewCellModel {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal var possiblePaymentOptions: [PaymentOption] {
        
        if let existingBrand = self.definedCardBrand?.cardBrand {
            
            let possiblePaymentOptions = self.paymentOptions.filter {
                
                var allCardBrands: [CardBrand] = [$0.brand]
                allCardBrands.append(contentsOf: $0.supportedCardBrands)
                allCardBrands = Array(Set(allCardBrands))
                
                return allCardBrands.contains(existingBrand)
            }
            
            return possiblePaymentOptions
        }
        else {
            
            return self.paymentOptions
        }
    }
    
    // MARK: Methods

    internal func bind(_ inputField: UIResponder?, displayLabel: UILabel?, editableView: TapEditableView? = nil, for validation: ValidationType) {
        
        switch validation {
            
        case .cardNumber:
            
            self.prepareCardNumberValidator(with: inputField)
            
        case .expirationDate:
            
            self.prepareExpirationDateValidator(with: inputField, editableView: editableView)
        
        case .cvv:
            
            self.prepareCVVValidator(with: inputField)
            
        case .nameOnCard:
            
            self.prepareNameOnCardValidator(with: inputField)
            
        case .addressOnCard:
            
            self.prepareAddressOnCardValidator(with: displayLabel)
            
        case .saveCard:
            
            self.prepareSaveCardValidator(with: inputField)

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
    
    private func prepareCardNumberValidator(with inputField: UIResponder?) {
        
        guard let textField = inputField as? UITextField else {
            
            fatalError("Card input field should be a text field.")
        }
        
        let validator = CardNumberValidator(textField: textField,
                                            availableCardBrands: self.availableCardBrands,
                                            preferredCardBrands: self.preferredCardBrands)
        
        validator.brandReporting = self
        
        self.finishSettingUp(validator)
    }
    
    private func prepareExpirationDateValidator(with inputField: UIResponder?, editableView: TapEditableView?) {
        
        guard let textField = inputField as? UITextField else {
            
            fatalError("Expiration date input field should be a text field.")
        }
        
        guard let nonnullEditableView = editableView else {
            
            fatalError("Expiration date input field should have editable view on top.")
        }
        
        let validator = ExpirationDateValidator(editableView: nonnullEditableView,
                                                textField: textField)
        
        self.finishSettingUp(validator)
    }
    
    private func prepareCVVValidator(with inputField: UIResponder?) {
        
        guard let textField = inputField as? UITextField else {
            
            fatalError("CVV input field should be a text field.")
        }
        
        let validator = CVVValidator(textField: textField)
        
        self.finishSettingUp(validator)
    }
    
    private func prepareNameOnCardValidator(with inputField: UIResponder?) {
        
        guard let textField = inputField as? UITextField else {
            
            fatalError("Name on Card input field should be a text field.")
        }
        
        let validator = CardholderNameValidator(textField: textField)
       
        self.finishSettingUp(validator)
    }
    
    private func prepareAddressOnCardValidator(with displayLabel: UILabel?) {
        
        guard let label = displayLabel else {
            
            fatalError("Address on Card requires a display label.")
        }
        
        let validator = CardAddressValidator(displayLabel: label)
        
        self.finishSettingUp(validator)
    }
    
    private func prepareSaveCardValidator(with inputField: UIResponder?) {
        
        guard let saveCardSwitch = inputField as? UISwitch else {
            
            fatalError("Save card input field should be a switch.")
        }
        
        let validator = SaveCardValidator(switch: saveCardSwitch)
        
        self.finishSettingUp(validator)
    }
    
    private func finishSettingUp(_ validator: CardValidator) {
        
        validator.delegate = self
        
        if let existingValidatorIndex = self.cardDataValidators.index(where: { $0.validationType == validator.validationType }) {
            
            self.cardDataValidators.remove(at: existingValidatorIndex)
        }
        
        self.cardDataValidators.append(validator)
        self.updateValidatorWithInputData(validator)
    }
    
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
        
        let visiblePaymentOptions = self.possiblePaymentOptions
        let possibleImageURLs = visiblePaymentOptions.map { $0.imageURL }
        let toBeDisplayedCellModels = self.tableViewCellModels.filter { possibleImageURLs.contains($0.imageURL) }
        self.displayedTableViewCellModels = toBeDisplayedCellModels
    }
}
