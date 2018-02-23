//
//  SecureEncodable.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Secure Encodable protocol.
internal protocol SecureEncodable: Encodable { }

internal extension SecureEncodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Secure encodes the model.
    ///
    /// - Parameter encoder: Encoder to use.
    /// - Returns: Secure encoded model.
    /// - Throws: Either encoding error or serialization error.
    internal func secureEncoded(using encoder: JSONEncoder = JSONEncoder()) throws -> String {
        
        let jsonData = try encoder.encode(self)
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            
            throw TapSerializationError.wrongData
        }
        
        guard let encrypted = Crypter.encrypt(jsonString, using: goSellSDK.encryptionKey) else {
            
            throw TapSerializationError.wrongData
        }
        
        return encrypted
    }
}
