//
//  CardAddressValidator.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class UIKit.UILabel.UILabel

/// Card address validator.
internal class CardAddressValidator: CardValidator {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal var selectedAddressFormat: BillingAddressFormat? {
        
        didSet {
            
            self.updateDisplayTextAndCallDelegateIfValidationStateChanged()
        }
    }
    
    /// User selected country (or initially preselected)
    internal var country: Country? {
        
        get {
            
            return self.inputData[AddressFieldsDataManager.Constants.countryFieldName] as? Country
        }
        set {
            
            self.inputData[AddressFieldsDataManager.Constants.countryFieldName] = newValue
        }
    }
    
    /// Address display text.
    internal var displayText: String {
        
        guard let format: BillingAddressFormat = self.selectedAddressFormat else {
            
            return Constants.placeholderDisplayText
        }
        
        if self.hasInputDataForCurrentAddressFormat {
            
            let orderedDisplayData: [BillingAddressField] = format.fields.sorted { $0.displayOrder < $1.displayOrder }
            var filledFields: [String] = orderedDisplayData.compactMap { self.inputData[$0.name] as? String }
            filledFields = filledFields.filter { $0.tap_length > 0 }
            
            if filledFields.count == 0 { return Constants.placeholderDisplayText }
            
            if let nonnullCountry: Country = self.country {
                
                filledFields.append(nonnullCountry.displayValue)
            }
            
            let result: String = filledFields.joined(separator: Constants.addressFieldsDisplaySeparatorText)
            return result
        }
        else {
            
            return Constants.placeholderDisplayText
        }
    }
    
    /// Defines if current address format has any input data.
    internal var hasInputDataForCurrentAddressFormat: Bool {
        
        guard let format = self.selectedAddressFormat else { return false }
        
        return format.fields.first(where: { self.inputData[$0.name] != nil }) != nil
    }
    
    internal override var isValid: Bool {
        
        guard let format = self.selectedAddressFormat else { return false }
        
        return format.fields.first(where: { !self.isDataValid(for: $0) }) == nil
    }
	
	internal override var errorCode: ErrorCode? {
		
		return self.isValid ? nil : .invalidAddress
	}
	
    internal var address: Address? {
        
        guard let format = self.selectedAddressFormat else { return nil }
        return Address(inputData: self.inputData, format: format)
    }
    
    // MARK: Methods
    
    internal init(displayLabel: UILabel) {
        
        self.displayLabel = displayLabel
        super.init(validationType: .addressOnCard)
    }
    
    internal override func update(with inputData: Any?) {
        
        if let correctInputData = inputData as? [String: Any] {
            
            self.inputData = correctInputData
        }
        else {
            
            self.inputData = [:]
        }
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let placeholderDisplayText = "Address on Card"
        fileprivate static let addressFieldsDisplaySeparatorText = ", "
        
        //@available(*, unavailable) private init() { }
    }
    
    // MARK: Properties
    
    private unowned var displayLabel: UILabel
    
    private var inputData: [String: Any] = [:] {
        
        didSet {
            
            self.updateDisplayTextAndCallDelegateIfValidationStateChanged()
            
            self.delegate?.cardValidator(self, inputDataChanged: self.inputData)
        }
    }
    
    // MARK: Methods
    
    private func updateDisplayTextAndCallDelegateIfValidationStateChanged() {
        
        self.updateInputFieldTextAndAttributes()
        self.validate()
    }
    
    private func isDataValid(for field: BillingAddressField) -> Bool {
        
        let specification = AddressFieldsDataManager.fieldSpecification(for: field)
        let data = self.inputData[field.name]
        
        return field.canBeFilled(with: data, considering: specification)
    }
}

// MARK: - CardAddressDataStorage
extension CardAddressValidator: CardAddressDataStorage {
    
    internal func cardInputData(for field: BillingAddressField) -> Any? {
        
        return self.inputData[field.name]
    }
}

// MARK: - CardAddressInputListener
extension CardAddressValidator: CardAddressInputListener {
    
    internal func inputChanged(in field: BillingAddressField, to value: Any?) {
        
        self.inputData[field.name] = value
    }
}

// MARK: - TextLabelInputDataValidation
extension CardAddressValidator: TextLabelInputDataValidation {
    
    internal var labelField: UILabel {
        
        return self.displayLabel
    }
    
    internal var textInputFieldText: String {
        
        return self.displayText
    }
    
    internal func updateSpecificInputFieldAttributes() {}
}
