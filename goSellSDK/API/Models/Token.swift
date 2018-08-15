//
//  Token.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Token model.
internal struct Token: IdentifiableWithString, Decodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal private(set) var identifier: String?
    
    /// Object type.
    internal let object: String
    
    /// Tokenized card.
    internal let card: TokenizedCard
    
    /// Token type.
    internal let type: TokenType
    
    /// Token creation date.
    internal let creationDate: Date
    
    /// Client IP address.
    internal private(set) var clientIPAddress: String?
    
    /// Defines if object is existing in live mode.
    internal let isLiveMode: Bool
    
    /// Defines if token is used.
    internal let isUsed: Bool
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case identifier         = "id"
        case object             = "object"
        case card               = "card"
        case type               = "type"
        case creationDate       = "created"
        case clientIPAddress    = "client_ip"
        case isLiveMode         = "live_mode"
        case isUsed             = "used"
    }
}
