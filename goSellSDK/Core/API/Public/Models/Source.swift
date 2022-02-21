//
//  Source.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import enum TapCardVlidatorKit_iOS.CardBrand

/// Source model.
@objcMembers public final class Source: SourceRequest {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Object type.
    public private(set) var object: SourceObject
    
    /// Source type.
    public private(set) var type: SourceType
    
    /// Source payment type.
    public private(set) var paymentType: SourcePaymentType
    
    /// Payment method.
    public private(set) var paymentMethod: CardBrand
    
    /// Source channel.
    public private(set) var channel: SourceChannel
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case identifier     = "id"
        case object         = "object"
        case type           = "type"
        case paymentType    = "payment_type"
        case paymentMethod  = "payment_method"
        case channel        = "channel"
    }
    
    // MARK: Methods
    
    private init(identifier: String, object: SourceObject, type: SourceType, paymentType: SourcePaymentType, paymentMethod: CardBrand, channel: SourceChannel) {
        
        self.object         = object
        self.type           = type
        self.paymentType    = paymentType
        self.paymentMethod  = paymentMethod
        self.channel        = channel
    
        super.init(identifier)
    }
}

// MARK: - Decodable
extension Source: Decodable {
    
    public convenience init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let identifier      = try container.decode(String.self,         forKey: .identifier)
        let object          = try container.decode(SourceObject.self,   forKey: .object)
        let type            = try container.decodeIfPresent(SourceType.self,        forKey: .type)          ?? .null
        let paymentType     = try container.decodeIfPresent(SourcePaymentType.self, forKey: .paymentType)   ?? .null
        let paymentMethod   = try container.decodeIfPresent(CardBrand.self,         forKey: .paymentMethod) ?? .unknown
        let channel         = try container.decodeIfPresent(SourceChannel.self,     forKey: .channel)       ?? .null
        
        self.init(identifier:       identifier,
                  object:           object,
                  type:             type,
                  paymentType:      paymentType,
                  paymentMethod:    paymentMethod,
                  channel:          channel)
    }
}
