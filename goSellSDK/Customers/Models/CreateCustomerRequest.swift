//
//  CreateCustomerRequest.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Model to create customer.
@objcMembers public class CreateCustomerRequest: NSObject, Encodable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// The customer’s email address.
    public var email: String
    
    /// Customer phone (including extension).
    public var phone: String
    
    /// Customer name.
    public var name: String
    
    /// An arbitrary string attached to the object. Often useful for displaying to users.
    public var descriptionText: String?
    
    /// Three-letter ISO code for the currency the customer can be charged.
    public var currency: String?
    
    /// Set of key/value pairs that you can attach to an object.
    /// It can be useful for storing additional information about the object in a structured format.
    public var metadata: [String: String]?
    
    // MARK: Methods
    
    /// Initializes the model with name, phone and email
    ///
    /// - Parameters:
    ///   - name: Customer name.
    ///   - phone: Customer phone.
    ///   - email: Customer email.
    public init(name: String, phone: String, email: String) {
        
        self.name = name
        self.phone = phone
        self.email = email
    }
    
    /// Initializes the model with name, phone, email, description text, currency and metadata.
    ///
    /// - Parameters:
    ///   - name: Customer name.
    ///   - phone: Customer phone.
    ///   - email: Customer email.
    ///   - descriptionText: Customer description.
    ///   - currency: Customer currency.
    ///   - metadata: Customer metadata.
    public convenience init(name: String, phone: String, email: String, descriptionText: String?, currency: String?, metadata: [String: String]?) {
        
        self.init(name: name, phone: phone, email: email)
        
        self.descriptionText = descriptionText
        self.currency = currency
        self.metadata = metadata
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case email
        case phone
        case name
        case descriptionText = "description"
        case currency
        case metadata
    }
}
