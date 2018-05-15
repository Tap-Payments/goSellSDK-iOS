//
//  CreateCustomerRequest.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Create customer request model.
internal struct CreateCustomerRequest: Encodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal let email: EmailAddress
    
    internal let phone: String
    
    internal let name: String
    
    // MARK: Methods
    
    internal init(email: EmailAddress, phone: String, name: String, surname: String?) {
        
        self.email = email
        self.phone = phone
        
        if let nonnullSurname = surname {
            
            self.name = name + " " + nonnullSurname
        }
        else {
            
            self.name = name
        }
    }
}
