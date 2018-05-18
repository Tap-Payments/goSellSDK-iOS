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
    
    internal override var isValid: Bool {
        
        let address = self.addressOnCard
        
        switch self.addressFormat {
            
        case .us:
            
            return
                
                ( address.country != nil                                        &&
                  !(address.city ?? .empty).isEmpty                             &&
                  !(address.state ?? .empty).isEmpty                            &&
                  !(address.zipCode ?? .empty).isEmpty                          &&
                  (address.zipCode ?? .empty).containsOnlyInternationalDigits   &&
                  !(address.line1 ?? .empty).isEmpty )
        }
    }
    
    internal var displayText: String? {
        
        let address = self.addressOnCard
        
        switch self.addressFormat {
            
        case .us:
            
            let parts = [
                
                [address.line1, address.line2].compactMap { $0 },
                [address.city, address.state, address.zipCode].compactMap { $0 },
                [address.country?.displayName].compactMap { $0 }
            ]
            
            let lines = parts.map { $0.joined(separator: ", ") }
            let result = lines.joined(separator: "\n")
            
            return result
        }
    }
    
    internal var hasInputDataForCurrentAddressFormat: Bool {
        
        let address = self.addressOnCard
        
        switch self.addressFormat {
            
        case .us:
            
            return
            
                ( address.country != nil                &&
                  !(address.city ?? .empty).isEmpty     &&
                  !(address.state ?? .empty).isEmpty    &&
                  !(address.zipCode ?? .empty).isEmpty  &&
                  !(address.line1 ?? .empty).isEmpty )
        }
    }
    
    /// Address on card.
    internal var addressOnCard: AddressOnCard {
        
        return AddressOnCard(country: self.inputData[.country] as? Country,
                             city: self.inputData[.city] as? String,
                             state: self.inputData[.state] as? String,
                             zipCode: self.inputData[.zip] as? String,
                             line1: self.inputData[.line1] as? String,
                             line2: self.inputData[.line2] as? String)
    }
    
    internal var addressFormat: AddressFormat = .us
    
    // MARK: Methods
    
    internal init(displayLabel: UILabel) {
        
        self.displayLabel = displayLabel
        super.init(validationType: .addressOnCard)
    }
    
    internal override func update(with inputData: Any?) {
        
        if let correctInputData = inputData as? [AddressField: Any] {
            
            self.inputData = correctInputData
        }
        else {
            
            self.inputData = [:]
        }
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private unowned var displayLabel: UILabel
    
    private lazy var inputData: [AddressField: Any] = [:]
}

// MARK: - CardAddressInputListener
extension CardAddressValidator: CardAddressInputListener {
    
    internal func inputChanged(in field: AddressField, to value: Any?) {
        
        self.inputData[field] = value
    }
}
