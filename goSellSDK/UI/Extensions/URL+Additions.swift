//
//  URL+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal extension URL {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal subscript(tap_queryParameter: String) -> String? {
        
        guard let queryParameters = URLComponents(string: self.absoluteString), let queryItems = queryParameters.queryItems else { return nil }
        guard let queryItem = queryItems.first(where: { $0.name == tap_queryParameter }) else { return nil }
        
        return queryItem.value
    }
}
