//
//  CustomerInfo.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Customer model.
@objcMembers public final class CustomerInfo: NSObject, Codable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Customer identifier (if you know it).
    public var identifier: String?
    
    /// Customer's email address.
    public var emailAddress: EmailAddress?
    
    /// Customer's phone number.
    public var phoneNumber: String?
    
    /// Customer's first name.
    public var firstName: String?
    
    /// Customer's last name.
    public var lastName: String?
    
    // MARK: Methods
    
    /// Initializes the customer with email address, phone number and a name.
    ///
    /// - Parameters:
    ///   - emailAddress: Email address.
    ///   - phoneNumber: Phone number.
    ///   - name: Name
    public convenience init(emailAddress: EmailAddress, phoneNumber: String, name: String) throws {
        
        try self.init(emailAddress: emailAddress, phoneNumber: phoneNumber, firstName: name, lastName: nil)
    }
    /// Initializes the customer with email address, phone number, first name and last name.
    ///
    /// - Parameters:
    ///   - emailAddress: Email address.
    ///   - phoneNumber: Phone number.
    ///   - firstName: First name.
    ///   - lastName: Last name.
    public convenience init(emailAddress: EmailAddress, phoneNumber: String, firstName: String, lastName: String?) throws {
        
        try self.init(identifier: nil, emailAddress: emailAddress, phoneNumber: phoneNumber, firstName: firstName, lastName: lastName)
    }
    
    /// Initializes the customer with the customer identifier.
    ///
    /// - Parameter identifier: Customer identifier.
    public convenience init(identifier: String) throws {
        
        try self.init(identifier: identifier, emailAddress: nil, phoneNumber: nil, firstName: nil, lastName: nil)
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        
        guard let otherCustomer = object as? CustomerInfo else { return false }
        
        if let firstIdentifier = self.identifier, let otherIdentifier = otherCustomer.identifier, firstIdentifier.length > 0, otherIdentifier.length > 0 {
            
            return firstIdentifier == otherIdentifier
        }
        
        return
            
            self.firstName      == otherCustomer.firstName      &&
            self.lastName       == otherCustomer.lastName       &&
            self.emailAddress   == otherCustomer.emailAddress   &&
            self.phoneNumber    == otherCustomer.phoneNumber
    }
    
    public static func == (lhs: CustomerInfo, rhs: CustomerInfo) -> Bool {
        
        return lhs.isEqual(rhs)
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case identifier     = "id"
        case emailAddress   = "email_address"
        case phoneNumber    = "phone_number"
        case firstName      = "first_name"
        case lastName       = "last_name"
    }
    
    // MARK: Methods
    
    @available(*, unavailable) private override init() { super.init() }
    
    private init(identifier: String?, emailAddress: EmailAddress?, phoneNumber: String?, firstName: String?, lastName: String?) throws {
        
        guard (identifier != nil) || (emailAddress != nil && phoneNumber != nil && firstName != nil) else {
            
            let userInfo = [ErrorConstants.UserInfoKeys.customerInfo: "Failed to create the customer: Either identifier shouldn't be nil or email address, phone number and at least first name shouldn't be nil."]
            let underlyingError = NSError(domain: ErrorConstants.internalErrorDomain, code: InternalError.invalidCustomerInfo.rawValue, userInfo: userInfo)
            throw TapSDKKnownError(type: .internal, error: underlyingError, response: nil)
        }
        
        self.identifier = identifier
        self.emailAddress = emailAddress
        self.phoneNumber = phoneNumber
        self.firstName = firstName?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.lastName = lastName?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        super.init()
    }
}

// MARK: - NSCopying
extension CustomerInfo: NSCopying {
    
    public func copy(with zone: NSZone? = nil) -> Any {
        
        let emailAddressCopy = self.emailAddress?.copy() as? EmailAddress
        return try! CustomerInfo(identifier: self.identifier, emailAddress: emailAddressCopy, phoneNumber: self.phoneNumber, firstName: self.firstName, lastName: self.lastName)
    }
}
