//
//  Response.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Response structure.
internal struct Response: Decodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Response code.
    internal let code: String
    
    /// Response message.
    internal let message: String
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case code       = "code"
        case message    = "message"
    }
}
