//
//  EmailAddress.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
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
    /// - Parameter emailAddressString: Email address string.
    /// - Throws: error in case if email address is invalid.
    public required init(emailAddressString: String) throws {
        
        guard emailAddressString.tap_isValidEmailAddress else {
            
            let userInfo = [ErrorConstants.UserInfoKeys.emailAddress: emailAddressString]
            let underlyingError = NSError(domain: ErrorConstants.internalErrorDomain, code: InternalError.invalidEmail.rawValue, userInfo: userInfo)
			throw TapSDKKnownError(type: .internal, error: underlyingError, response: nil, body: nil)
        }
        
        self.value = emailAddressString
        
        super.init()
    }
    
    /// Initializes email address with a string value.
    ///
    /// - Parameter emailAddressString: Email address string.
    /// - Warning: This method returns `nil` if email address is not valid.
    @available(swift, obsoleted: 1.0)
    @objc(initWithEmailAddressString:)
    public convenience init?(with emailAddressString: String) {
        
        try? self.init(emailAddressString: emailAddressString)
    }
    
    
    
    /// Creates and returns an instance of `EmailAddress` with a given email address string.
    ///
    /// - Parameter emailAddressString: Email address string.
    /// - Returns: An instance of `EmailAddress` or `nil` if email address is not valid.
    @objc(withEmailAddressString:) public static func with(_ emailAddressString: String) -> EmailAddress? {
        
        return try? EmailAddress(emailAddressString: emailAddressString)
    }
    
    /// Checks if the receiver is equal to `object.`
    ///
    /// - Parameter object: Object to test equality with.
    /// - Returns: `true` if the receiver is equal to `object`, `false` otherwise.
    public override func isEqual(_ object: Any?) -> Bool {
        
        guard let otherEmailAddress = object as? EmailAddress else { return false }
        
        return self.value == otherEmailAddress.value
    }
    
    /// Checks if 2 objects are equal.
    ///
    /// - Parameters:
    ///   - lhs: First object.
    ///   - rhs: Second object.
    /// - Returns: `true` if 2 objects are equal, `fale` otherwise.
    public static func == (lhs: EmailAddress, rhs: EmailAddress) -> Bool {
        
        return lhs.isEqual(rhs)
    }
}

// MARK: - Encodable
extension EmailAddress: Encodable {
	
	/// Encodes the contents of the receiver.
	///
	/// - Parameter encoder: Encoder.
	/// - Throws: EncodingError
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
        
        try self.init(emailAddressString: value)
    }
}

// MARK: - NSCopying
extension EmailAddress: NSCopying {
    
    /// Copies the receiver.
    ///
    /// - Parameter zone: Zone.
    /// - Returns: Copy of the receiver.
    public func copy(with zone: NSZone? = nil) -> Any {
        
        return try! EmailAddress(emailAddressString: self.value)
    }
}
