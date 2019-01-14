//
//  AuthenticationRequest.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Structure to authenticate the charge.
internal struct AuthenticationRequest: Encodable {
    
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
