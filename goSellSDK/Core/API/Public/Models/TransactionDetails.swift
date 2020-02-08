//
//  TransactionDetails.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//
/// Transaction details model.
@objcMembers public final class TransactionDetails: NSObject {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Transaction authorization identifier.
    public private(set) var authorizationID: String?
    
    /// Transaction creation date.
    public let creationDate: Date
    
    /// Transaction time zone.
    public let timeZone: String
    
    /// Transaction URL.
    public let url: URL?
    
    /// Indicate whether this transaction is async or sync
    public let asynchronous:Bool?
    
    /// Indicate of this is an async, when it will be expired
    public let expiry:TransactionExpiry?
    
    /// Indicate of this is an async, when it will be expired
    public let order:TransactionOrder?
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case authorizationID    = "authorization_id"
        case creationDate       = "created"
        case timeZone           = "timezone"
        case url                = "url"
        case expiry             = "expiry"
        case order              = "order"
        case asynchronous       = "asynchronous"
    }
    
    // MARK: Methods
    
    private init(authorizationID: String?, creationDate: Date, timeZone: String, url: URL?, expiry:TransactionExpiry?, asynchronous:Bool? = false, order:TransactionOrder?) {
        
        self.authorizationID    = authorizationID
        self.creationDate       = creationDate
        self.timeZone           = timeZone
        self.url                = url
        self.expiry             = expiry
        self.asynchronous       = asynchronous
        self.order              = order
        super.init()
    }
}

// MARK: - Decodable
extension TransactionDetails: Decodable {
    
    public convenience init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let authorizationID = try container.decodeIfPresent (String.self,   forKey: .authorizationID)
        let expiry          = try container.decodeIfPresent (TransactionExpiry.self,   forKey: .expiry)
        let order          = try container.decodeIfPresent (TransactionOrder.self,   forKey: .order)
        let asynchronous    = try container.decodeIfPresent (Bool.self,   forKey: .asynchronous)
        let creationDate    = try container.decode          (Date.self,     forKey: .creationDate)
        let timeZone        = try container.decode          (String.self,   forKey: .timeZone)
        let url             = container.decodeURLIfPresent(for: .url)
        
        self.init(authorizationID: authorizationID, creationDate: creationDate, timeZone: timeZone, url: url, expiry: expiry, asynchronous:asynchronous, order:order)
    }
}
