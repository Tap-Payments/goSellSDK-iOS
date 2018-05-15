//
//  CustomerInfo.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Customer model.
@objcMembers public final class CustomerInfo: NSObject, Encodable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Customer identifier (if you know it).
    public private(set) var identifier: String?
    
    /// Customer's email address.
    public private(set) var emailAddress: EmailAddress?
    
    /// Customer's phone number.
    public private(set) var phoneNumber: String?
    
    /// Customer's first name.
    public private(set) var firstName: String?
    
    /// Customer's last name.
    public private(set) var lastName: String?
    
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
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case identifier = "id"
        case emailAddress = "email_address"
        case phoneNumber = "phone_number"
        case firstName = "first_name"
        case lastName = "last_name"
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
