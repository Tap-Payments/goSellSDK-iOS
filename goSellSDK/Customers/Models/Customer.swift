//
//  Customer.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

// MARK: - Customer -

/// Customer model.
@objcMembers public class Customer: NSObject, Decodable, Identifiable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Unique identifier for the object.
    public private(set) var identifier: String?
    
    /// String representing the object’s type. Objects of the same type share the same value.
    public private(set) var object: String?
    
    /// Customer name
    public private(set) var name: String?
    
    /// Three-letter ISO code for the currency the customer can be charged
    public private(set) var currency: String?
    
    /// An arbitrary string attached to the object. Often useful for displaying to users.
    public private(set) var descriptionText: String?
    
    /// The customer’s email address.
    public private(set) var email: String?
    
    /// Customer phone (including extension).
    public private(set) var phone: String?
    
    /// Set of key/value pairs that you can attach to an object.
    /// It can be useful for storing additional information about the object in a structured format.
    public private(set) var metadata: [String: String]?
    
    /// Time at which the object was created. Measured in seconds since the Unix epoch.
    public private(set) var creationDate: String?
    
    /// Flag indicating whether the object exists in live mode or test mode.
    public private(set) var isLiveMode: Bool?
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case identifier         = "id"
        case object             = "object"
        case name               = "name"
        case currency           = "currency"
        case descriptionText    = "description"
        case email              = "email"
        case phone              = "phone"
        case metadata           = "metadata"
        case creationDate       = "created"
        case isLiveMode         = "live_mode"
    }
}
