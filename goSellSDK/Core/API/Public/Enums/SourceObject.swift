//
//  SourceObject.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Source object enum.
@objc public enum SourceObject: Int {
    
    /// Token source.
    case token
    
    /// Static source.
    case source
    
    // MARK: - Private -
    // MARK: Properties
    
    private var stringValue: String {
        
        switch self {
            
        case .token:    return "TOKEN"
        case .source:   return "SOURCE"
            
        }
    }
    
    // MARK: Methods
    
    private init(_ stringValue: String) throws {
        
        switch stringValue.uppercased() {
            
        case SourceObject.token.stringValue: self = .token
        case SourceObject.source.stringValue: self = .source
            
        default:
            
            throw ErrorUtils.createEnumStringInitializationError(for: SourceObject.self, value: stringValue)
        }
    }
}

// MARK: - Encodable
extension SourceObject: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        try container.encode(self.stringValue)
    }
}

// MARK: - Decodable
extension SourceObject: Decodable {
	
	/// Encodes the contents of the receiver.
	///
	/// - Parameter encoder: Encoder.
	/// - Throws: EncodingError
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        
        try self.init(stringValue)
    }
}
