//
//  CardValidator.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
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
	
	internal var errorCode: ErrorCode? {
		
		return nil
	}
	
    // MARK: Methods
    
    /// Initializes CardValidator instance with the given validation type. Must not be called directly.
    ///
    /// - Parameter validationType: Validation type.
    internal init(validationType: ValidationType) {
        
        self.validationType = validationType
    }
    
    internal func validate() {
        
        let valid = self.isDataValid
        if self.wasDataValidOnPreviousValidationCall != valid {
            
            self.wasDataValidOnPreviousValidationCall = valid
            self.delegate?.validationStateChanged(to: valid, on: self.validationType)
        }
    }
    
    internal func update(with inputData: Any?) {
        
        fatalError("Should be implemented in subclasses")
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private var wasDataValidOnPreviousValidationCall = false
}

// MARK: - DataValidation
extension CardValidator: DataValidation {
    
    internal var isDataValid: Bool {
        
        return self.isValid
    }
}
