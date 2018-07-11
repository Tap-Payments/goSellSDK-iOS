//
//  ChargeAuthenticationRequest.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Structure to authenticate the charge.
internal struct ChargeAuthenticationRequest: Encodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Authentication type.
    internal let type: AuthenticationType
    
    /// Authentication value.
    internal let value: String
    
    // MARK: Methods
    
    internal init(type: AuthenticationType, value: String) {
        
        self.type   = type
        self.value  = value
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case type   = "type"
        case value  = "value"
    }
}
