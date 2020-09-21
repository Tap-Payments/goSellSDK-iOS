//
//  Encodable+Additions.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation

internal extension Encodable {
    
    var dictionaryRepresentation: [String: Any]? {
        
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        let object = try? JSONSerialization.jsonObject(with: data, options: [])
        
        if let dictionaryObject = object as? [String: Any] {
            
            return dictionaryObject
        }
        else {
            
            return nil
        }
    }
}
