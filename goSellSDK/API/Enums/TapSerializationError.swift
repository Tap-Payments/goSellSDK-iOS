//
//  TapSerializationError.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Serialization error.
///
/// - wrongData: Wrong data to serialize/deserialize.
public enum TapSerializationError: Int, Error {
    
    /// Wrong data to serialize/deserialize.
    case wrongData
    
    internal var readableType: String {
        
        switch self {
            
        case .wrongData:
            
            return "Wrong data"
        }
    }
}

// MARK: - CustomStringConvertible
extension TapSerializationError: CustomStringConvertible {
    
    public var description: String {
        
        return self.readableType
    }
}
