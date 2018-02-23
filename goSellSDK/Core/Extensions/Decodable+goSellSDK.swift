//
//  Decodable+goSellSDK.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Useful extension to Decodable protocol.
internal extension Decodable {
    
    // MARK: - Internal -
    // MARK: Methods
    
    /// Initializes Decodable instance with the dictionary using specified decoder.
    ///
    /// - Parameters:
    ///   - dictionary: Dictionary to decode.
    ///   - decoder: Decoder.
    /// - Throws: Decoding error.
    internal init(dictionary: [String: Any], using decoder: JSONDecoder = JSONDecoder()) throws {
        
        let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        
        self = try decoder.decode(Self.self, from: jsonData)
    }
}
