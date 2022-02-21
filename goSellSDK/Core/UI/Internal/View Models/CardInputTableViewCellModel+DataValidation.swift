//
//  CardInputTableViewCellModel+DataValidation.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import enum     TapCardVlidatorKit_iOS.CardBrand
import struct   TapCardVlidatorKit_iOS.DefinedCardBrand
import class    TapEditableViewV2.TapEditableView
import struct    TapAdditionsKitV2.TypeAlias
import class    UIKit.UILabel.UILabel
import class    UIKit.UIResponder.UIResponder
import class    UIKit.UISwitch.UISwitch
import class    UIKit.UITextField.UITextField

internal extension CardInputTableViewCellModel {
    
    // MARK: - Internal -
    // MARK: Properties
    
    var possiblePaymentOptions: [PaymentOption] {
        
        if self.shouldUseCardSchemeBrand {
            
            guard let brand = self.definedCardBrand?.scheme?.cardBrand else { return self.paymentOptions }
            
            if let option = self.paymentOptions.first(where: { $0.brand == brand }) {
                
                return [option]
            }
            else {
                
                return self.paymentOptions
            }
        }
        else if let existingBrand = self.definedCardBrand?.brand {
            
            let possiblePaymentOptions = self.paymentOptions.filter {
                
                var allCardBrands: [CardBrand] = [$0.brand]
                allCardBrands.append(contentsOf: $0.supportedCardBrands)
                allCardBrands = Array(Set(allCardBrands))
                
                return allCardBrands.contains(existingBrand)
            }
            
            return possiblePaymentOptions.count > 0 ? possiblePaymentOptions : self.paymentOptions
        }
        else {
            
            return self.paymentOptions
        }
    }
    
    // MARK: Methods

    func bind(_ inputField: UIResponder?, displayLabel: UILabel?, editableView: TapEditableView? = nil, for validation: ValidationType) {
        
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
            
			self.prepareSaveCardValidator(with: inputField, descriptionLabel: displayLabel)
        }
    }
    
    func updateValidatorWithInputData(of type: ValidationType) {
        
        if let validator = self.validator(of: type) {
            
            self.updateValidatorWithInputData(validator)
        }
    }
    
    func validator(of type: ValidationType) -> CardValidator? {
        
        return self.cardDataValidators.first { $0.validationType == type }
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let binNumberLength = 6
        
        //@available(*, unavailable) private init() { }
    }
    
    // MARK: Properties
    
    private var availableCardBrands: [CardBrand] {
        
        return self.paymentOptions.flatMap { $0.supportedCardBrands }
    }
    
    private var preferredCardBrands: [CardBrand] {
        
        return self.paymentOptions.map { $0.brand }
    }
    
    private var shouldUseCardSchemeBrand: Bool {
        
        if let schemeBrand = self.definedCardBrand?.scheme?.cardBrand {
            
            return self.paymentOptions.first(where: { $0.brand == schemeBrand }) != nil
        }
        else {
            
            return false
        }
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
    
	private func prepareSaveCardValidator(with inputField: UIResponder?, descriptionLabel: UILabel?) {
        
        guard let saveCardSwitch = inputField as? UISwitch else {
            
            fatalError("Save card input field should be a switch.")
        }
		
		guard let label = descriptionLabel else {
			
			fatalError("Description label cannot be nil.")
		}
		
		let validator = SaveCardValidator(switch: saveCardSwitch, label: label)
        
        self.finishSettingUp(validator)
    }
    
    private func finishSettingUp(_ validator: CardValidator) {
        
        validator.delegate = self
        
        if let existingValidatorIndex = self.cardDataValidators.firstIndex(where: { $0.validationType == validator.validationType }) {
            
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
        
        if cardInAllowedCardTypes(newBINData)
        {
            print("CARD ACCEPTED")
        }else
        {
            showUnSupportedCardTypeAlert() { [weak self] (clearCardField) in
                if clearCardField
                {
                    self?.cardTypeNotSupported()
                }
            }
            print("CARD NOT SUPPORTED")
        }
    }
    
    private func cardInAllowedCardTypes(_ newBINData: BINResponse?)-> Bool {
        
        if let nonNullBinData = newBINData {
           if let allowedCards = Process.shared.allowedCardTypes
           {
                return allowedCards.contains(nonNullBinData.cardType)
            }
        }
        
        return true
    }
    
    private func cardTypeNotSupported()
    {
        self.cell?.unSpportedCardType()
        
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
		
		Process.shared.buttonHandlerInterface.updateButtonState()
		
		let ready = self.isReadyForPayment
		
		let saveCardValidator = self.validator(of: .saveCard) as? SaveCardValidator
		saveCardValidator?.canSaveCard = ready
		
		if ready && Process.shared.dataManagerInterface.shouldToggleSaveCardSwitchToOnAutomatically {
			
			saveCardValidator?.toggleSwitchOn()
		}
		else if !ready {
			
			saveCardValidator?.toggleSwitchOff()
		}
	}
}

// MARK: - CardBrandChangeReporting
extension CardInputTableViewCellModel: CardBrandChangeReporting {
    
    internal func cardNumberValidator(_ validator: CardNumberValidator, cardNumberInputChanged cardNumber: String) {
        
        if cardNumber.tap_length < Constants.binNumberLength {
            
            self.actualBinDataUpdated(nil)
            return
        }
        
        BINDataManager.shared.retrieveBINData(for: cardNumber.tap_substring(to: Constants.binNumberLength)) { (response) in
            
            let inputCardNumber = validator.cardNumber
            let outputBINNumber = response.binNumber
            let inputTrimmedTo6Characters = inputCardNumber.tap_length < Constants.binNumberLength ? String.tap_empty : inputCardNumber.tap_substring(to: Constants.binNumberLength)
            let outputTrimmedTo6Characters = outputBINNumber.tap_length < Constants.binNumberLength ? String.tap_empty : outputBINNumber.tap_substring(to: Constants.binNumberLength)
            if inputTrimmedTo6Characters == outputTrimmedTo6Characters {
                
                self.actualBinDataUpdated(response)
            }
        }
    }
    
    internal func recognizedCardBrandChanged(_ definedCardBrand: BrandWithScheme) {
        
        self.definedCardBrand = definedCardBrand
        
        if let cvvValidator = (self.cardDataValidators.first { $0.validationType == .cvv }) as? CVVValidator {
            
            cvvValidator.cardBrand = definedCardBrand.brand
        }
        
        self.updateDisplayedTableViewCellModels()
    }
    
    internal func updateDisplayedTableViewCellModels() {
        
        let visiblePaymentOptions = self.possiblePaymentOptions
        let possibleURLs = visiblePaymentOptions.map { $0.imageURL }
        
        let toBeDisplayedCellModels = self.tableViewCellModels.filter { possibleURLs.contains($0.imageURL) }
        self.displayedTableViewCellModels = toBeDisplayedCellModels
    }
}


extension CardInputTableViewCellModel
{
    private func showUnSupportedCardTypeAlert( decision: @escaping TypeAlias.BooleanClosure) {
        
        UIResponder.tap_resign {
            
            let alert = TapAlertController(titleKey:         .alert_un_supported_card_title,
                                           messageKey:         .alert_un_supported_card_message,
                                           preferredStyle:    .alert)
            
            let confirmAction = TapAlertController.Action(titleKey: .alert_un_supported_card_btn_confirm_title, style: .default) { [weak alert] (action) in
                
                alert?.hide()
                decision(true)
            }
            
            alert.addAction(confirmAction)
            
            alert.show()
        }
    }
}
