//
//  Customer.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Customer model.
@objcMembers public class Customer: NSObject, Encodable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Customer's email address.
    public var emailAddress: EmailAddress
    
    /// Customer's phone number.
    public var phoneNumber: String
    
    /// Customer's first name.
    public var firstName: String
    
    /// Customer's last name.
    public var lastName: String?
    
    // MARK: Methods
    
    /// Initializes the customer with email address, phone number and a name.
    ///
    /// - Parameters:
    ///   - emailAddress: Email address.
    ///   - phoneNumber: Phone number.
    ///   - name: Name
    public convenience init(emailAddress: EmailAddress, phoneNumber: String, name: String) {
        
        self.init(emailAddress: emailAddress, phoneNumber: phoneNumber, firstName: name, lastName: nil)
    }
    /// Initializes the customer with email address, phone number, first name and last name.
    ///
    /// - Parameters:
    ///   - emailAddress: Email address.
    ///   - phoneNumber: Phone number.
    ///   - firstName: First name.
    ///   - lastName: Last name.
    public init(emailAddress: EmailAddress, phoneNumber: String, firstName: String, lastName: String?) {
        
        self.emailAddress = emailAddress
        self.phoneNumber = phoneNumber
        self.firstName = firstName
        self.lastName = lastName
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case emailAddress = "email_address"
        case phoneNumber = "phone_number"
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
