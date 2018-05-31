//
//  UpdateCustomerRequest.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Model to update the customer.
@objcMembers public final class UpdateCustomerRequest: NSObject, Encodable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// An arbitrary string attached to the object. Often useful for displaying to users.
    public var descriptionText: String?
    
    /// The customer’s email address.
    public var email: String?
    
    /// Customer name
    public var name: String?
    
    /// Customer phone (including extension).
    public var phone: String?
    
    /// Set of key/value pairs that you can attach to an object.
    /// It can be useful for storing additional information about the object in a structured format.
    public var metadata: [String: String]?
    
    // MARK: Methods
    
    /// Empty constructor.
    public override init() { super.init() }
    
    /// Initializes the model with the description, email, name, phone and metadata.
    ///
    /// - Parameters:
    ///   - descriptionText: Updated description.
    ///   - email: Updated email.
    ///   - name: Updated name.
    ///   - phone: Update phone.
    ///   - metadata: Updated metadata.
    public convenience init(descriptionText: String?, email: String?, name: String?, phone: String?, metadata: [String: String]?) {
        
        self.init()
        
        self.descriptionText = descriptionText
        self.email = email
        self.name = name
        self.phone = phone
        self.metadata = metadata
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case descriptionText = "description"
        case email
        case name
        case phone
        case metadata
    }
}
