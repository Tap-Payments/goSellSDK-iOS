//
//  EmailAddress.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Email address model.
@objcMembers public final class EmailAddress: NSObject {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Email address string value.
    public let value: String
    
    // MARK: Methods
    
    /// Initializes email address with a string value.
    ///
    /// - Parameter value: Email address string.
    /// - Throws: error in case if email address is invalid.
    public required init(_ value: String) throws {
        
        guard value.isValidEmailAddress else {
            
            let userInfo = [ErrorConstants.UserInfoKeys.emailAddress: value]
            let underlyingError = NSError(domain: ErrorConstants.internalErrorDomain, code: InternalError.invalidEmail.rawValue, userInfo: userInfo)
            throw TapSDKKnownError(type: .internal, error: underlyingError, response: nil)
        }
        
        self.value = value
        
        super.init()
    }
}

// MARK: - Encodable
extension EmailAddress: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        try container.encode(self.value)
    }
}

// MARK: - Decodable
extension EmailAddress: Decodable {
    
    public convenience init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        
        try self.init(value)
    }
}
