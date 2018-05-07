//
//  TapSDKErrorType.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Enum describing error type.
///
/// - api: API error.
/// - network: Network error.
/// - serialization: Serialization error.
/// - unknown: Unknown error.
public enum TapSDKErrorType: Int {
    
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
    
    /// Readable error type.
    internal var readableType: String {
        
        switch self {
            
        case .api: return "API"
        case .network: return "Network"
        case .serialization: return "Serialization"
        case .internal: return "Internal"
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
