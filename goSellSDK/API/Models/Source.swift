//
//  Source.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import enum TapCardValidator.CardBrand

/// Source model.
internal struct Source: Identifiable, Codable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// A payment source to be charged, such as a credit card.
    /// If you also pass a customer ID, the source must be the ID of a source belonging to the customer (e.g., a saved card).
    /// Otherwise, if you do not pass a customer ID, the source you provide must can be a token or card id or source id.
    /// Default source id's (KNET - src_kw.knet, Visa/MasterCard - src_visamastercard)
    internal private(set) var identifier: String?
    
    /// Object type.
    internal private(set) var object: SourceObject?
    
    /// Source type.
    internal private(set) var type: SourceType?
    
    /// Source payment type.
    internal private(set) var paymentType: SourcePaymentType?
    
    /// Payment method.
    internal private(set) var paymentMethod: CardBrand?
    
    /// Source channel.
    internal private(set) var channel: SourceChannel?
    
    // MARK: Methods
    
    /// Initializes source object with static identifier.
    ///
    /// - Parameter identifier: Static source identifier.
    internal init(identifier: SourceIdentifier) {
        
        self.identifier = identifier.stringValue
    }
    
    /// Initializes source object with token.
    ///
    /// - Parameter token: Token to initialize source with.
    internal init(token: Token) {
        
        self.identifier = token.identifier
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case identifier     = "id"
        case object         = "object"
        case type           = "type"
        case paymentType    = "payment_type"
        case paymentMethod  = "payment_method"
        case channel        = "channel"
    }
}
