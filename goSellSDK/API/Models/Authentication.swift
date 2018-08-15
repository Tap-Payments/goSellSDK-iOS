//
//  Authentication.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal final class Authentication: IdentifiableWithString {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal private(set) var identifier: String?
    
    internal let object: String
    
    internal let type: AuthenticationType
    
    internal let requirer: AuthenticationRequirer
    
    internal let status: AuthenticationStatus
    
    internal let retryAttemptsCount: Int
    
    internal let url: URL?
    
    internal let creationDate: Date
    
    internal let authenticationDate: Date?
    
    internal let count: Int
    
    internal let value: String
    
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
    
    internal convenience init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let identifier          = try container.decode          (String.self,                   forKey: .identifier)
        let object              = try container.decode          (String.self,                   forKey: .object)
        let type                = try container.decode          (AuthenticationType.self,       forKey: .type)
        let requirer            = try container.decode          (AuthenticationRequirer.self,   forKey: .requirer)
        let status              = try container.decode          (AuthenticationStatus.self,     forKey: .status)
        let retryAttemptsCount  = try container.decode          (Int.self,                      forKey: .retryAttemptsCount)
        let url                 = try container.decodeIfPresent (URL.self,                      forKey: .url)
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
