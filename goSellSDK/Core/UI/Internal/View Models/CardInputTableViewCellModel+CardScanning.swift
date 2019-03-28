//
//  CardInputTableViewCellModel+CardScanning.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal extension CardInputTableViewCellModel {
    
    // MARK: - Internal -
    // MARK: Methods
    
    func update(withScanned cardNumber: String?, expirationDate: ExpirationDate?, cvv: String?, cardholderName: String?) {
        
        if let nonnullCardNumber = cardNumber {
            
            self.inputData[.cardNumber] = nonnullCardNumber
            self.updateValidatorWithInputData(of: .cardNumber)
        }
        
        if let nonnullExpiryDate = expirationDate {
            
            self.inputData[.expirationDate] = nonnullExpiryDate
            self.updateValidatorWithInputData(of: .expirationDate)
        }
        
        if let nonnullCVV = cvv {
            
            self.inputData[.cvv] = nonnullCVV
            self.updateValidatorWithInputData(of: .cvv)
        }
        
        if let nonnullCardholderName = cardholderName {
            
            self.inputData[.nameOnCard] = nonnullCardholderName
            self.updateValidatorWithInputData(of: .nameOnCard)
        }
    }
    
}
