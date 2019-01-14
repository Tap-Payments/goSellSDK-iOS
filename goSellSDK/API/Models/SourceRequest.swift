//
//  SourceRequest.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Source request model for the charge.
@objcMembers public class SourceRequest: NSObject, IdentifiableWithString, Encodable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Source identifier.
    public let identifier: String
    
    // MARK: - Internal -
    // MARK: Methods
    
    /// Initializes source object with static identifier.
    ///
    /// - Parameter identifier: Static source identifier.
    internal convenience init(identifier: String) {
        
        self.init(identifier)
    }
    
    /// Initializes source object with token.
    ///
    /// - Parameter token: Token to initialize source with.
    internal convenience init(token: Token) {
        
        self.init(token.identifier)
    }
    
    internal init(_ identifier: String) {
        
        self.identifier = identifier
        super.init()
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case identifier = "id"
    }
}
