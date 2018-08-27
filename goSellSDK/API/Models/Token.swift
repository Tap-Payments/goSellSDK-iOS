//
//  Token.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Token model.
internal struct Token: IdentifiableWithString {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Unique token identifier.
    internal let identifier: String
    
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
    
    // MARK: Methods
    
    private init(identifier: String, object: String, card: TokenizedCard, type: TokenType, creationDate: Date, clientIPAddress: String?, isLiveMode: Bool, isUsed: Bool) {
        
        self.identifier         = identifier
        self.object             = object
        self.card               = card
        self.type               = type
        self.creationDate       = creationDate
        self.clientIPAddress    = clientIPAddress
        self.isLiveMode         = isLiveMode
        self.isUsed             = isUsed
    }
}

// MARK: - Decodable
extension Token: Decodable {
    
    internal init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let identifier      = try container.decode          (String.self,           forKey: .identifier)
        let object          = try container.decode          (String.self,           forKey: .object)
        let card            = try container.decode          (TokenizedCard.self,    forKey: .card)
        let type            = try container.decode          (TokenType.self,        forKey: .type)
        let creationDate    = try container.decode          (Date.self,             forKey: .creationDate)
        let clientIPAddress = try container.decodeIfPresent (String.self,           forKey: .clientIPAddress)
        let isLiveMode      = try container.decode          (Bool.self,             forKey: .isLiveMode)
        let isUsed          = try container.decode          (Bool.self,             forKey: .isUsed)
        
        self.init(identifier:       identifier,
                  object:           object,
                  card:             card,
                  type:             type,
                  creationDate:     creationDate,
                  clientIPAddress:  clientIPAddress,
                  isLiveMode:       isLiveMode,
                  isUsed:           isUsed)
    }
}
