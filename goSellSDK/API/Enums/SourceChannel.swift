//
//  SourceChannel.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

@objc public enum SourceChannel: Int {
    
    case callCentre
    case internet
    case mailOrder
    case moto
    case telephoneOrder
    case voiceResponse 
    
    case null
    
    // MARK: - Private -
    // MARK: Properties
    
    private var stringValue: String {
        
        switch self {
            
        case .callCentre:       return "CALL_CENTRE"
        case .internet:         return "INTERNET"
        case .mailOrder:        return "MAIL_ORDER"
        case .moto:             return "MOTO"
        case .telephoneOrder:   return "TELEPHONE_ORDER"
        case .voiceResponse:    return "VOICE_RESPONSE"
        case .null:             return "null"
            
        }
    }
    
    // MARK: Methods
    
    private init(_ stringValue: String) throws {
        
        switch stringValue {
            
        case SourceChannel.callCentre.stringValue:      self = .callCentre
        case SourceChannel.internet.stringValue:        self = .internet
        case SourceChannel.mailOrder.stringValue:       self = .mailOrder
        case SourceChannel.moto.stringValue:            self = .moto
        case SourceChannel.telephoneOrder.stringValue:  self = .telephoneOrder
        case SourceChannel.voiceResponse.stringValue:   self = .voiceResponse
            
        default:
            
            throw ErrorUtils.createEnumStringInitializationError(for: SourceChannel.self, value: stringValue)
            
        }
    }
}

// MARK: - Encodable
extension SourceChannel: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        try container.encode(self.stringValue)
    }
}

// MARK: - Decodable
extension SourceChannel: Decodable {
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        
        try self.init(stringValue)
    }
}
