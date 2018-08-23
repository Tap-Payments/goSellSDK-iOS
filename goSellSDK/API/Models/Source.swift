//
//  Source.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import enum TapCardValidator.CardBrand

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
        
        let identifier      = try container.decode(String.self, forKey: .identifier)
        let object          = try container.decode(SourceObject.self, forKey: .object)
        let type            = try container.decode(SourceType.self, forKey: .type)
        let paymentType     = try container.decode(SourcePaymentType.self, forKey: .paymentType)
        let paymentMethod   = try container.decode(CardBrand.self, forKey: .paymentMethod)
        let channel         = try container.decode(SourceChannel.self, forKey: .channel)
        
        self.init(identifier:       identifier,
                  object:           object,
                  type:             type,
                  paymentType:      paymentType,
                  paymentMethod:    paymentMethod,
                  channel:          channel)
    }
}
