//
//  TransactionDetails.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

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
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case authorizationID    = "authorization_id"
        case creationDate       = "created"
        case timeZone           = "timezone"
        case url                = "url"
    }
    
    // MARK: Methods
    
    private init(authorizationID: String?, creationDate: Date, timeZone: String, url: URL?) {
        
        self.authorizationID    = authorizationID
        self.creationDate       = creationDate
        self.timeZone           = timeZone
        self.url                = url
        
        super.init()
    }
}

// MARK: - Decodable
extension TransactionDetails: Decodable {
    
    public convenience init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let authorizationID = try container.decodeIfPresent (String.self,   forKey: .authorizationID)
        let creationDate    = try container.decode          (Date.self,     forKey: .creationDate)
        let timeZone        = try container.decode          (String.self,   forKey: .timeZone)
        let url             = try container.decodeIfPresent (URL.self,      forKey: .url)
        
        self.init(authorizationID: authorizationID, creationDate: creationDate, timeZone: timeZone, url: url)
    }
}
