//
//  TapSDKErrorType.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Enum describing error type.
///
/// - api: API error.
/// - network: Network error.
/// - serialization: Serialization error.
/// - unknown: Unknown error.
@objc public enum TapSDKErrorType: Int {
    
    /// API error.
    case api
    
    /// Network error.
    case network
    
    /// Serialization error.
    case serialization
    
    /// Internal error.
    case `internal`
    
    /// Unknown error.
    case unknown
    
    case unVerifiedApplication

    
    // MARK: - Private -
    // MARK: Properties
    
    /// Readable error type.
    private var readableType: String {
        
        switch self {
            
        case .api: return "API"
        case .network: return "Network"
        case .serialization: return "Serialization"
        case .internal: return "Internal"
        case .unVerifiedApplication: return "Un verified Application"
        case .unknown: return "Unknown"
        }
    }
}

// MARK: - CustomStringConvertible
extension TapSDKErrorType: CustomStringConvertible {
    
    public var description: String {
        
        return self.readableType
    }
}

// MARK: - Encodable
extension TapSDKErrorType: Encodable {
	
	/// Encodes the contents of the receiver.
	///
	/// - Parameter encoder: Encoder.
	/// - Throws: EncodingError
	public func encode(to encoder: Encoder) throws {
		
		var container = encoder.singleValueContainer()
		try container.encode(self.readableType)
	}
}
