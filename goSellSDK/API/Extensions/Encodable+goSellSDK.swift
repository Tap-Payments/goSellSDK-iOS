//
//  Encodable+goSellSDK.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class Foundation.NSJSONSerialization.JSONEncoder
import class Foundation.NSJSONSerialization.JSONSerialization

/// Useful extension to Encodable protocol.
internal extension Encodable {
    
    // MARK: - Internal -
    // MARK: Methods
    
    /// Encodes the receiver into dictionary.
    ///
    /// - Parameter encoder: Encoder.
    /// - Returns: Dictionary representation of the receiver.
    /// - Throws: Encoding error.
    internal func asDictionary(using encoder: JSONEncoder = JSONEncoder()) throws -> [String: Any] {
        
        let data = try encoder.encode(self)
        let object = try JSONSerialization.jsonObject(with: data, options: [])
        
        guard let dictionaryObject = object as? [String: Any] else {
            
            throw TapSerializationError.wrongData
        }
        
        return dictionaryObject
    }
}
