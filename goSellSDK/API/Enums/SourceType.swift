//
//  SourceType.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

@objc public enum SourceType: Int {
    
    case cardPresent
    case cardNotPresent
    
    // MARK: - Private -
    
    private var stringValue: String {
        
        switch self {
            
        case .cardPresent: return "CARD_PRESENT"
        case .cardNotPresent: return "CARD_NOT_PRESENT"

        }
    }
    
    // MARK: Methods
    
    private init(_ stringValue: String) throws {
        
        switch stringValue {
            
        case SourceType.cardPresent.stringValue: self = .cardPresent
        case SourceType.cardNotPresent.stringValue: self = .cardNotPresent
        
        default:
            
            throw ErrorUtils.createEnumStringInitializationError(for: SourceType.self, value: stringValue)
        }
    }
}

// MARK: - Encodable
extension SourceType: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        try container.encode(self.stringValue)
    }
}

// MARK: - Decodable
extension SourceType: Decodable {
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        
        try self.init(stringValue)
    }
}
