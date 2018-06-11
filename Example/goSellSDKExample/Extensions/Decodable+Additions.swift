//
//  Decodable+Additions.swift
//  goSellSDKExample
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class Foundation.NSJSONSerialization.JSONDecoder
import class Foundation.NSJSONSerialization.JSONSerialization

internal extension Decodable {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal init?(dictionaryRepresentation: [String: Any]) {
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dictionaryRepresentation, options: []) else { return nil }
        
        if let result = try? JSONDecoder().decode(Self.self, from: jsonData) {
        
            self = result
        }
        else {
            
            return nil
        }
    }
}
