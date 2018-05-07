//
//  CardValidator.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Card validator base class.
internal class CardValidator {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Validation type.
    internal let validationType: ValidationType
    
    /// Delegate.
    internal weak var delegate: CardValidatorDelegate?
    
    internal var isValid: Bool {
        
        fatalError("Should be implemented by subclasses.")
    }
    
    // MARK: Methods
    
    /// Initializes CardValidator instance with the given validation type. Must not be called directly.
    ///
    /// - Parameter validationType: Validation type.
    internal init(validationType: ValidationType) {
        
        self.validationType = validationType
        
        self.checkProtocolConformancesAndPresetup()
    }
    
    internal func validate() {
        
        let isValid = self.isDataValid
        if self.wasDataValidOnPreviousValidationCall != isValid {
            
            self.wasDataValidOnPreviousValidationCall = isValid
            self.delegate?.validationStateChanged(to: isValid, on: self.validationType)
        }
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private var wasDataValidOnPreviousValidationCall = false
    
    // MARK: Methods
    
    private func checkProtocolConformancesAndPresetup() {
        
//        if let textFieldValidator = self as? TextInputDataValidation {
//
//            textFieldValidator.updateInputFieldAttributes()
//        }
    }
}

// MARK: - DataValidation
extension CardValidator: DataValidation {
    
    internal var isDataValid: Bool {
        
        return self.isValid
    }
}
