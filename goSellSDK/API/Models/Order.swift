//
//  Order.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal struct Order: IdentifiableWithString, Encodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal let identifier: String
    
    // MARK: Methods
    
    internal init(identifier: String) {
        
        self.identifier = identifier
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case identifier = "id"
    }
}
