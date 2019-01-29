//
//  Response.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Response structure.
@objcMembers public final class Response: NSObject {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Response code.
    public let code: String
    
    /// Response message.
    public let message: String
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case code       = "code"
        case message    = "message"
    }
    
    // MARK: Methods
    
    private init(code: String, message: String) {
        
        self.code       = code
        self.message    = message
        
        super.init()
    }
}

// MARK: - Decodable
extension Response: Decodable {
    
    public convenience init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let code    = try container.decode(String.self, forKey: .code)
        let message = try container.decode(String.self, forKey: .message)
        
        self.init(code: code, message: message)
    }
}
