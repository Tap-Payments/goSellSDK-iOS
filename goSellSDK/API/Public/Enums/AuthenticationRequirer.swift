//
//  AuthenticationRequirer.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Entity requiring authentication.
@objc public enum AuthenticationRequirer: Int {
    
    /// Service provider (Tap)
    case provider
    
    /// Merchant.
    case merchant
    
    /// Cardholder
    case cardholder
    
    // MARK: - Private -
    // MARK: Properties
    
    private var stringValue: String {
        
        switch self {
            
        case .provider:     return "PROVIDER"
        case .merchant:     return "MERCHANT"
        case .cardholder:   return "CARDHOLDER"

        }
    }
    
    // MARK: Methods
    
    private init(_ stringValue: String) throws {
        
        switch stringValue {
            
        case AuthenticationRequirer.provider.stringValue:   self = .provider
        case AuthenticationRequirer.merchant.stringValue:   self = .merchant
        case AuthenticationRequirer.cardholder.stringValue: self = .cardholder
            
        default:
            
            throw ErrorUtils.createEnumStringInitializationError(for: AuthenticationRequirer.self, value: stringValue)
        }
    }
}

// MARK: - Decodable
extension AuthenticationRequirer: Decodable {
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        
        let stringValue = try container.decode(String.self)
        try self.init(stringValue)
    }
}
