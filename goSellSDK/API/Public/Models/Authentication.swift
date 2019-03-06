//
//  Authentication.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Authentication class.
@objcMembers public final class Authentication: NSObject, IdentifiableWithString {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Authentication identifier.
    public let identifier: String
    
    /// Object type.
    public let object: String
    
    /// Authentication type.
    public let type: AuthenticationType
    
    /// Authentication requirer.
    public let requirer: AuthenticationRequirer
    
    /// Authentication status.
    public let status: AuthenticationStatus
    
    /// Retry attempts count.
    public let retryAttemptsCount: Int
    
    /// URL.
    public let url: URL?
    
    /// Creation date.
    public let creationDate: Date
    
    /// Authentication date.
    public let authenticationDate: Date?
    
    /// Count.
    public let count: Int
    
    /// Authentication value.
    public let value: String
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case identifier         = "id"
        case object             = "object"
        case type               = "type"
        case requirer           = "by"
        case status             = "status"
        case retryAttemptsCount = "retry_attempt"
        case url                = "url"
        case creationDate       = "created"
        case authenticationDate = "authenticated"
        case count              = "count"
        case value              = "value"
    }
    
    // MARK: Methods
    
    private init(identifier: String,
                 object: String,
                 type: AuthenticationType,
                 requirer: AuthenticationRequirer,
                 status: AuthenticationStatus,
                 retryAttemptsCount: Int,
                 url: URL?,
                 creationDate: Date,
                 authenticationDate: Date?,
                 count: Int,
                 value: String) {
        
        self.identifier         = identifier
        self.object             = object
        self.type               = type
        self.requirer           = requirer
        self.status             = status
        self.retryAttemptsCount = retryAttemptsCount
        self.url                = url
        self.creationDate       = creationDate
        self.authenticationDate = authenticationDate
        self.count              = count
        self.value              = value
    }
}

// MARK: - Decodable
extension Authentication: Decodable {
    
    public convenience init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let identifier          = try container.decode          (String.self,                   forKey: .identifier)
        let object              = try container.decode          (String.self,                   forKey: .object)
        let type                = try container.decode          (AuthenticationType.self,       forKey: .type)
        let requirer            = try container.decode          (AuthenticationRequirer.self,   forKey: .requirer)
        let status              = try container.decode          (AuthenticationStatus.self,     forKey: .status)
        let retryAttemptsCount  = try container.decode          (Int.self,                      forKey: .retryAttemptsCount)
        let url                 = container.decodeURLIfPresent(for: .url)
        let creationDate        = try container.decode          (Date.self,                     forKey: .creationDate)
        let authenticationDate  = try container.decodeIfPresent (Date.self,                     forKey: .authenticationDate)
        let count               = try container.decode          (Int.self,                      forKey: .count)
        let value               = try container.decode          (String.self,                   forKey: .value)
        
        self.init(identifier: identifier,
                  object: object,
                  type: type,
                  requirer: requirer,
                  status: status,
                  retryAttemptsCount: retryAttemptsCount,
                  url: url,
                  creationDate: creationDate,
                  authenticationDate: authenticationDate,
                  count: count,
                  value: value)
    }
}
