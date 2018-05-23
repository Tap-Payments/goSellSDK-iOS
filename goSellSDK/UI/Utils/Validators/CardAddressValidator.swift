//
//  CardAddressValidator.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class UIKit.UILabel.UILabel

/// Card address validator.
internal class CardAddressValidator: CardValidator {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// BIN information.
    internal var binInformation: BINResponse? {
        
        didSet {
            
            if self.country == nil {
                
                self.country = self.binInformation?.country
            }
        }
    }
    
    /// User selected country (or initially preselected)
    internal var country: Country? {
        
        get {
            
            return self.inputData[AddressFieldsDataManager.Constants.countryPlaceholder] as? Country
        }
        set {
            
            self.inputData[AddressFieldsDataManager.Constants.countryPlaceholder] = newValue
        }
    }
    
    /// Address display text.
    internal var displayText: String {
        
        if self.hasInputDataForCurrentAddressFormat {
            
            let orderedDisplayData = self.binInformation?.addressFormat?.sorted { $0.displayOrder < $1.displayOrder }
            var filledFields = orderedDisplayData?.compactMap { self.inputData[$0.placeholder] as? String }
            filledFields = filledFields?.filter { $0.length > 0 }
            
            if (filledFields?.count ?? 0) == 0 {
                
                return Constants.placeholderDisplayText
            }
            
            if let country = self.country {
                
                filledFields?.append(country.displayValue)
            }
            
            if let nonnullFields = filledFields, nonnullFields.count > 0 {
                
                return nonnullFields.joined(separator: Constants.addressFieldsDisplaySeparatorText)
            }
            else {
                
                return Constants.placeholderDisplayText
            }
        }
        else {
            
            return Constants.placeholderDisplayText
        }
    }
    
    /// Defines if current address format has any input data.
    internal var hasInputDataForCurrentAddressFormat: Bool {
        
        guard let nonnullAddressFormat = self.binInformation?.addressFormat else { return false }
        
        return nonnullAddressFormat.first(where: { self.inputData[$0.placeholder] != nil }) != nil
    }
    
    internal override var isValid: Bool {
        
        guard let addressFormat = self.binInformation?.addressFormat else { return true }
        return addressFormat.first(where: { !$0.canBeFilled(with: self.inputData[$0.placeholder]) }) == nil
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
        
        @available(*, unavailable) private init() {}
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
}

// MARK: - CardAddressDataStorage
extension CardAddressValidator: CardAddressDataStorage {
    
    internal func cardInputData(for field: AddressField) -> Any? {
        
        return self.inputData[field.placeholder]
    }
}

// MARK: - CardAddressInputListener
extension CardAddressValidator: CardAddressInputListener {
    
    internal func inputChanged(in field: AddressField, to value: Any?) {
        
        self.inputData[field.placeholder] = value
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
