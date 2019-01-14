//
//  AuthenticationStatus.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Status of authentication.
@objc public enum AuthenticationStatus: Int {
    
    /// Authentication was initiated.
    case initiated
    
    /// Authentication succeed.
    case authenticated
    
    /// Authentication not yet succeed.
    case notAuthenticated
    
    /// Authentication was abandoned.
    case abandoned
    
    /// Authentication failed.
    case failed
    
    // MARK: - Private -
    // MARK: Properties
    
    private var stringValue: String {
        
        switch self {
            
        case .initiated:        return "INITIATED"
        case .authenticated:    return "AUTHENTICATED"
        case .notAuthenticated: return "NOT_AUTHENTICATED"
        case .abandoned:        return "ABANDONED"
        case .failed:           return "FAILED"

        }
    }
    
    // MARK: Methods
    
    private init(_ stringValue: String) throws {
        
        switch stringValue {
            
        case AuthenticationStatus.initiated.stringValue:        self = .initiated
        case AuthenticationStatus.authenticated.stringValue:    self = .authenticated
        case AuthenticationStatus.notAuthenticated.stringValue: self = .notAuthenticated
        case AuthenticationStatus.abandoned.stringValue:        self = .abandoned
        case AuthenticationStatus.failed.stringValue:           self = .failed
            
        default:
            
            throw ErrorUtils.createEnumStringInitializationError(for: AuthenticationStatus.self, value: stringValue)
        }
    }
}

// MARK: - Decodable
extension AuthenticationStatus: Decodable {
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        
        let stringValue = try container.decode(String.self)
        try self.init(stringValue)
    }
}
